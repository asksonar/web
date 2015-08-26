VideoResize = function(config, video) {
  this.$scriptVideoResizeButtonTemplate = config.scriptVideoResizeButtonTemplate;
  this.resizeBtnAfterSelector = config.resizeBtnAfterSelector;
  this.resizeBtnSelector = config.resizeBtnSelector;
  this.$divVideoTranscriptContainer = config.divVideoTranscriptContainer;

  this.video = video;

  this.init();
}

VideoResize.prototype.init = function() {
  $(this.resizeBtnAfterSelector).after(this.$scriptVideoResizeButtonTemplate.html());

  this.$btnToggleViewMode = $(this.resizeBtnSelector);
  this.$btnToggleViewMode.on('click', $.proxy(this.toggleViewMode, this));

  this.setViewModeText();
}

VideoResize.prototype.setViewModeIcon = function(event) {
  this.$divVideoTranscriptContainer.addClass('icon-mode').removeClass('text-mode');
}

VideoResize.prototype.setViewModeText = function(event) {
  this.$divVideoTranscriptContainer.removeClass('icon-mode').addClass('text-mode');
}

VideoResize.prototype.toggleViewMode = function(event) {
  this.$divVideoTranscriptContainer.toggleClass('icon-mode').toggleClass('text-mode');
};
