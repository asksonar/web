VideoModal = function(config, video, transcript, videoLink) {
  this.$modal = config.modal;
  this.$divUserEmail = config.divUserEmail;
  this.$divStepOrder = config.divStepOrder;
  this.$divStepDescription = config.divStepDescription;

  this.$btnHighlightVideoLink = config.btnHighlightVideoLink;
  this.$btnToggleTranscripts = config.btnToggleTranscripts;
  this.$divVideoTranscriptContainer = config.divVideoTranscriptContainer;
  this.$btnAddNote = config.btnAddNote;

  this.video = video;
  this.transcript = transcript;
  this.videoLink = videoLink;

  this.videoResizeButton = Handlebars.compile(config.scriptVideoResizeButton.html());

  this.init();
};

VideoModal.prototype.init = function() {
  this.$modal.on('shown.bs.modal', $.proxy(this.shown, this));
  this.$modal.on('hide.bs.modal', $.proxy(this.hidden, this));
  this.$btnHighlightVideoLink.on('click', $.proxy(this.generateHighlight, this));
  this.$btnToggleTranscripts.on('click', $.proxy(this.toggleTranscripts, this));
  this.$btnAddNote.on('click', $.proxy(this.createNote, this));

  this.video.on('timeupdate', $.proxy(this.updateVideoTime, this));

  $('.vjs-control-bar .vjs-fullscreen-control').after(this.videoResizeButton({}));
  $('.vjs-custom-resize-control').on('click', $.proxy(this.toggleViewMode, this));

};

VideoModal.prototype.toggleTranscripts = function(event) {
  $(event.currentTarget).toggleClass('active');
  var activeTranscripts = this.$btnToggleTranscripts.hasClass('active');

  this.transcript.showTranscripts(activeTranscripts);
};

VideoModal.prototype.toggleViewMode = function(event) {
  this.$divVideoTranscriptContainer.toggleClass('icon-mode');
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
  if (this.resultStepHashId != data.result_step_hashid) {
    this.resultStepHashId = data.result_step_hashid;

    this.video.markers(data.delighted_array, data.confused_array, data.highlighted_array);
    this.video.src(data.src_array);

    this.transcript.buildTranscript(
      data.transcription_array,
      data.delighted_array,
      data.confused_array,
      data.highlighted_array
    );

    this.$divUserEmail.html(data.user_email);
    this.$divStepOrder.html(data.step_order + 1);
    this.$divStepDescription.html(data.step_description);

    this.videoLink.updateShareLink(data.share_link);
  }

  this.video.currentTime(timeSeconds);
  this.show();
};

VideoModal.prototype.focusLink = function(timeSeconds) {
  this.transcript.focusLink(timeSeconds);
};

VideoModal.prototype.show = function() {
  this.$modal.modal('show');
};

VideoModal.prototype.shown = function() {
  this.playVideo();
  if (location.href.indexOf('videos') < 0) {
    var newUrl = URI(location.href).segment('videos').segment(this.resultStepHashId).addSearch("t", 0);
    history.replaceState({}, '', newUrl);
  }

  autosize.update($('textarea'));
  $(window).load(function() {
    autosize.update($('textarea'));
  });
};

VideoModal.prototype.hidden = function() {
  this.pauseVideo();
  var newUrl = '/' + URI(location.href).segment(0) + '/' + URI(location.href).segment(1);
  history.replaceState({}, '', newUrl);
};

VideoModal.prototype.pauseVideo = function() {
  this.video.pause();
};

VideoModal.prototype.playVideo = function(timestamp) {
  this.video.play(timestamp);
};

VideoModal.prototype.updateVideoTime = function(event, timestamp) {
  this.videoLink.updateVideoTime(timestamp);
  this.transcript.activateLink(timestamp);
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

VideoModal.prototype.createNote = function() {
  var time = this.video.currentTime();
  this.transcript.createNote(time);
};
