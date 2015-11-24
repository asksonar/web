VideoModal = function(config, video, transcript, videoLink, videoHistory) {
  this.$modal = config.modal;
  this.$divTitle = config.divTitle;
  this.$divUserEmail = config.divUserEmail;
  this.$btnToggleViewMode = config.btnToggleViewMode;

  this.video = video;
  this.transcript = transcript;
  this.videoLink = videoLink;
  this.videoHistory = videoHistory;

  this.init();
};

VideoModal.prototype.init = function() {
  this.$modal.on('shown.bs.modal', $.proxy(this.shown, this));
  this.$modal.on('hide.bs.modal', $.proxy(this.hidden, this));
};

VideoModal.prototype.load = function(scenarioResultHashId, timeSeconds) {

  $.ajax({
    url:"/videos.json",
    data: {
      scenario_result_hashid: scenarioResultHashId
    },
    dataType: 'json',
    success: this.loaded.bind(this, timeSeconds),
    error: function(jqXHR) {
      notify.warn(jqXHR.responseText);
    }
  });
};

// timeSeconds comes first because $.proxy inserts it first
VideoModal.prototype.loaded = function(timeSeconds, data) {
  this.scenarioResultHashId = data.hashid;

  this.video.src(data.srcArray);

  var transcriptElement = modulejs.require('TranscriptElement');
  var noteElement = modulejs.require('NoteElement');
  var stepElement = modulejs.require('StepElement');

  var timelineArray = []
    .concat(stepElement.buildElementArray(data.stepArray))
    .concat(transcriptElement.buildElementArray(data.transcriptionArray))
    .concat(noteElement.buildElementArray(data.highlightedArray));

  this.transcript.buildTranscript(data.hashid, timelineArray);

  $('#btn-create-highlight').attr('data-base-url', '/highlights/new?video=' + data.hashid);

  this.videoLink.updateShareLink(data.shareLink);

  this.$divUserEmail.html(data.email);
  this.$divTitle.html(data.title);

  this.video.currentTime(timeSeconds);
  this.show();
  this.transcript.focusLink(timeSeconds);
};

VideoModal.prototype.show = function() {
  this.$modal.modal('show');
};

VideoModal.prototype.shown = function() {
  this.video.play();
  this.videoHistory.loadVideo(this.scenarioResultHashId);
  this.transcript.refreshView();
};

VideoModal.prototype.hidden = function() {
  this.video.pause();
  this.videoHistory.unloadVideo();
  this.transcript.clearView();
};
