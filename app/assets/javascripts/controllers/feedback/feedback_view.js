function FeedbackView(config, extension) {
  this.$btnRecordFeedback = config.btnRecordFeedback;

  this.extension = extension;

  this.initHandlers();
}

FeedbackView.prototype.initHandlers = function() {
  this.$btnRecordFeedback.on('click', this.recordFeedback.bind(this));
};

FeedbackView.prototype.recordFeedback = function() {
  if (!this.extension.hasChrome()) {
    notify.error('Get Chrome to record your screen and voice.');
  } else {
    this.extension.checkForExtension()
      .done(this.startFeedback.bind(this))
      .fail(
        function() {
          this.extension.installExtension()
            .done(this.startFeedback.bind(this));
        }
      );
  }
};

FeedbackView.prototype.startFeedback = function() {
  this.extension.startFeedback({'authenticity_token': AUTH_TOKEN}, 'expertFlow');
};
