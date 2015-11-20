function FeedbackView(config, extension, videoModal) {
  this.$btnRecordFeedback = config.btnRecordFeedback;

  this.extension = extension;
  this.videoModal = videoModal;

  this.initHandlers();
}

FeedbackView.prototype.initHandlers = function() {
  this.$btnRecordFeedback.on('click', this.recordFeedback.bind(this));
  $('.panel').on('click', this.loadVideoModal.bind(this));
};

FeedbackView.prototype.recordFeedback = function() {
  if (!this.extension.hasChrome()) {
    notify.error("Get Chrome to start recording. <a href='https://www.google.com/chrome/browser/desktop/index.html' target='_blank'>Install Chrome.</a>");
  } else {
    this.extension.checkForExtension()
      .done(this.startFeedback.bind(this))
      .fail(
        function() {
          notify.error('The extension needs to be added first. <a>Add the extension.</a>', null, this.addExtension.bind(this));
        }.bind(this)
      );
  }
};

FeedbackView.prototype.addExtension = function() {
  this.extension
    .installExtension()
    .done(
      this.startFeedback.bind(this)
    );
};

FeedbackView.prototype.startFeedback = function() {
  this.extension.startFeedback({'authenticity_token': AUTH_TOKEN}, 'expertFlow');
};

FeedbackView.prototype.loadVideoModal = function() {
  event.preventDefault();
  var thisEl = $(event.currentTarget);
  var scenarioResultHashId = thisEl.attr('data-scenario-result-hashid');
  var timeSeconds = parseFloat(thisEl.attr('data-result-step-offset-seconds') || 0);

  this.videoModal.load(scenarioResultHashId, timeSeconds);
};
