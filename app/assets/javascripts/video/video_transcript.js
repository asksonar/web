window.VideoTranscript = function(config) {
  this.$videoText = config.divVideoText;

  this.init();
};

VideoTranscript.prototype.init = function() {
  this.$videoText.on('click', '.videoTextLink', $.proxy(this.clickVideoText, this));
};

VideoTranscript.prototype.showTranscripts = function(showTranscripts) {
  if (showTranscripts === false) {
    this.$videoText.addClass('hide-transcripts');
  } else {
    this.$videoText.removeClass('hide-transcripts');
  }

}
