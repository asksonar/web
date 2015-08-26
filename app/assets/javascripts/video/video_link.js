VideoLink = function(config) {
  this.$inputUrlBase = config.inputUrlBase;
  this.$inputUrlTime = config.inputUrlTime;
  this.$btnCopyVideoLink = config.btnCopyVideoLink;
  this.$spanTime = config.spanTime;

  this.init();
};

VideoLink.prototype.init = function() {
  new ClipboardInput(this.$btnCopyVideoLink, this.$inputUrlBase);

  this.onTimeupdate = $.proxy(this.onTimeupdate, this);
}

VideoLink.prototype.onTimeupdate = function(event, timestamp) {
  this.updateVideoTime(timestamp);
}

VideoLink.prototype.updateVideoTime = function(timestamp) {
  var currentSeconds = parseInt(timestamp);

  var displayTime = Math.floor(currentSeconds / 60) + ':' + ('00' + currentSeconds % 60).slice(-2);
  this.$inputUrlTime.val(displayTime);
  this.$spanTime.text(displayTime);

  var displayUrl = this.$inputUrlBase.attr('data-base-url') + currentSeconds;
  var inputUrlBaseDom = this.$inputUrlBase.get(0);
  var selectionStart = inputUrlBaseDom.selectionStart;
  var selectionEnd = inputUrlBaseDom.selectionEnd;
  var selectionAll = inputUrlBaseDom.value.length > 0 && selectionEnd - selectionStart == inputUrlBaseDom.value.length;
  this.$inputUrlBase.val(displayUrl);
  if (this.$inputUrlBase.is(':focus')) {
    if (selectionAll) {
      inputUrlBaseDom.setSelectionRange(0, inputUrlBaseDom.value.length);
    } else {
      inputUrlBaseDom.setSelectionRange(selectionStart, selectionEnd);
    }
  }
}

VideoLink.prototype.updateShareLink = function(shareLink) {
  this.$inputUrlBase.attr('data-base-url', shareLink + '?t=');
  this.$inputUrlBase.val(shareLink + '?t=0');
}
