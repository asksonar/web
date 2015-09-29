VideoModal = function(config, video, transcript, videoLink) {
  this.$modal = config.modal;
  this.$divUserEmail = config.divUserEmail;
  this.$divStepOrder = config.divStepOrder;
  this.$divStepDescription = config.divStepDescription;
  this.$btnToggleViewMode = config.btnToggleViewMode;

  this.video = video;
  this.transcript = transcript;
  this.videoLink = videoLink;

  this.init();
};

VideoModal.prototype.init = function() {
  this.$modal.on('shown.bs.modal', $.proxy(this.shown, this));
  this.$modal.on('hide.bs.modal', $.proxy(this.hidden, this));
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
  this.resultStepHashId = data.hashid;

  this.video.src(data.srcArray);

  var transcriptElement = modulejs.require('TranscriptElement');
  var feelingDelightedElement = modulejs.require('FeelingDelightedElement');
  var feelingConfusedElement = modulejs.require('FeelingConfusedElement');
  var noteElement = modulejs.require('NoteElement');

  var timelineArray = []
    .concat(transcriptElement.buildElementArray(data.transcriptionArray))
    .concat(feelingDelightedElement.buildElementArray(data.delightedArray))
    .concat(feelingConfusedElement.buildElementArray(data.confusedArray))
    .concat(noteElement.buildElementArray(data.highlightedArray));

  this.transcript.buildTranscript(data.hashid, timelineArray);


  this.videoLink.updateShareLink(data.shareLink);

  // TODO: fix this
  $('#btn-create-highlight').attr('href', '/highlights/new?video=' + data.hashid);

  this.$divUserEmail.html(data.email);
  this.$divStepOrder.html(data.stepOrder + 1);
  this.$divStepDescription.html(data.stepDescription);

  this.video.currentTime(timeSeconds);
  this.show();
  this.transcript.focusLink(timeSeconds);
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
  this.transcript.clearView();
};
