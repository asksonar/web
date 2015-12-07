function FeedbackView(config, extension, videoModal) {
  this.$divAllContent = config.divAllContent;
  this.$btnRecordFeedback = config.btnRecordFeedback;
  this.$resultPanelToggle = config.resultPanelToggle;

  this.extension = extension;
  this.videoModal = videoModal;

  this.initHandlers();
}

FeedbackView.prototype.initHandlers = function() {
  this.$btnRecordFeedback.on('click', this.recordFeedback.bind(this));
  this.$divAllContent.on('click', '.video-link', $.proxy(this.loadVideoModal, this));
  this.$resultPanelToggle.on('click', 'li.active', $.proxy(this.collapseTab, this));
};

FeedbackView.prototype.collapseTab = function(event) {
  event.stopPropagation();

  var thisEl = $(event.currentTarget);
  thisEl.removeClass('active');
  thisEl.children().attr('aria-expanded', 'false');

  var $href = thisEl.children().attr('href');
  this.$resultPanelToggle.find($href).toggleClass('active');
};

FeedbackView.prototype.recordFeedback = function() {
  if (!this.extension.hasChrome()) {
    notify.error("Get Google Chrome to start recording. <a href='https://www.google.com/chrome/browser/desktop/index.html' target='_blank'>Install Chrome.</a>");
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

FeedbackView.prototype.loadVideoModal = function(event) {
  event.preventDefault();
  var thisEl = $(event.currentTarget);
  var scenarioResultHashId = thisEl.attr('data-scenario-result-hashid');
  var timeSeconds = parseFloat(thisEl.attr('data-result-step-offset-seconds') || 0);

  this.videoModal.load(scenarioResultHashId, timeSeconds);
};
