VideoModal = function(config, video, transcript, videoLink) {
  this.$modal = config.modal;
  this.$divUserEmail = config.divUserEmail;
  this.$divStepOrder = config.divStepOrder;
  this.$divStepDescription = config.divStepDescription;
  this.$btnToggleViewMode = config.btnToggleViewMode;

  // TODO: delete the highlight button and its associated logic
  this.$btnHighlightVideoLink = config.btnHighlightVideoLink;

  this.video = video;
  this.transcript = transcript;
  this.videoLink = videoLink;

  this.init();
};

VideoModal.prototype.init = function() {
  this.$modal.on('shown.bs.modal', $.proxy(this.shown, this));
  this.$modal.on('hide.bs.modal', $.proxy(this.hidden, this));

  this.$btnHighlightVideoLink.on('click', $.proxy(this.generateHighlight, this));
};

VideoModal.prototype.load = function(resultStepHashId, timeSeconds) {

  $.ajax({
    url:"/videos.json",
    data: {
      result_step_hashid: resultStepHashId
    },
    dataType: 'json'
  }).done($.proxy(this.loaded, this, timeSeconds
  )).fail($.proxy(function(jqXHR, textStatus, errorThrown) {
    notify.warn(jqXHR.responseText);
  }, this));
};

// timeSeconds comes first because $.proxy inserts it first
VideoModal.prototype.loaded = function(timeSeconds, data) {
  if (this.resultStepHashId != data.hashid) {
    this.resultStepHashId = data.hashid;

    this.video.markers(data.delightedArray, data.confusedArray, data.highlightedArray);
    this.video.src(data.srcArray);

    this.transcript.buildTranscript(
      data.hashid,
      data.transcriptionArray,
      data.delightedArray,
      data.confusedArray,
      data.highlightedArray
    );

    this.videoLink.updateShareLink(data.shareLink);

    this.$divUserEmail.html(data.email);
    this.$divStepOrder.html(data.stepOrder + 1);
    this.$divStepDescription.html(data.stepDescription);
  }

  this.video.currentTime(timeSeconds);
  this.show();
};

VideoModal.prototype.show = function() {
  this.$modal.modal('show');
};

VideoModal.prototype.shown = function() {
  this.video.play();
  new VideoHistory().loadVideo(this.resultStepHashId);
  this.transcript.refreshView();
};

VideoModal.prototype.hidden = function() {
  this.video.pause();
  new VideoHistory().unloadVideo();
};

VideoModal.prototype.generateHighlight = function() {
  var offsetSeconds = this.video.currentTime();

  $.ajax({
    type: "POST",
    url: "/highlights",
    data: {
      result_step_hashid: this.resultStepHashId,
      offset_seconds: offsetSeconds,
      authenticity_token: AUTH_TOKEN
    },
    dataType: 'json'
  }).done($.proxy(function(data){

    // draw the highlights
    this.video.markers(data.delighted_array, data.confused_array, data.highlighted_array);
    // normally triggered by calling this.video.src
    this.video.loadMarkers();

    notify.info('Your highlight has been added.');

  }, this)).fail($.proxy(function(jqXHR, textStatus, errorThrown){
    notify.error(jqXHR.responseText, 'There was an error saving your Highlight.');
  }, this));
};

