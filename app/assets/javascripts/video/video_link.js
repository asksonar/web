VideoLink = function(config) {
  this.$inputUrlBase = config.inputUrlBase;
  this.$btnCopyVideoLink = config.btnCopyVideoLink;
  this.$spanTime = config.spanTime;
  this.$hrefLink = config.hrefLink;

  this.init();
};

VideoLink.prototype.init = function() {
  new ClipboardInput(this.$btnCopyVideoLink, this.$inputUrlBase);

  this.onTimeupdate = $.proxy(this.onTimeupdate, this);
};

VideoLink.prototype.onTimeupdate = function(event, timeSeconds) {
  var currentSeconds = parseInt(timeSeconds);
  this.$spanTime.text(TimeDisplay.secsToDisplayTime(currentSeconds));
  this.updateVideoTime(currentSeconds);
  if (this.$hrefLink) {
    this.$hrefLink.attr('href', this.$hrefLink.attr('data-base-url') + '&t=' + parseInt(currentSeconds));
  }
};

VideoLink.prototype.updateVideoTime = function(currentSeconds) {
  var displayUrl = this.$inputUrlBase.attr('data-base-url') + currentSeconds;
  var inputUrlBaseDom = this.$inputUrlBase.get(0);
  var selectionStart = inputUrlBaseDom.selectionStart;
  var selectionEnd = inputUrlBaseDom.selectionEnd;
  var selectionAll = inputUrlBaseDom.value.length > 0 && (selectionEnd - selectionStart) == inputUrlBaseDom.value.length;
  this.$inputUrlBase.val(displayUrl);
  if (this.$inputUrlBase.is(':focus')) {
    if (selectionAll) {
      inputUrlBaseDom.setSelectionRange(0, inputUrlBaseDom.value.length);
    } else {
      inputUrlBaseDom.setSelectionRange(selectionStart, selectionEnd);
    }
  }
};

VideoLink.prototype.updateShareLink = function(shareLink) {
  this.$inputUrlBase.attr('data-base-url', shareLink + '?t=');
  this.$inputUrlBase.val(shareLink + '?t=0');
};
