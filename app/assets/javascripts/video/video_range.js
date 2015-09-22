VideoRange = function(config, video) {
  this.$inputStart = config.inputStart;
  this.$inputFinish = config.inputFinish;

  this.$scriptVideoRangeTemplate = config.scriptVideoRangeTemplate;
  this.progressControlSelector = config.progressControlSelector;
  this.rangeLeftMaskSelector = config.rangeLeftMaskSelector;
  this.rangeRightMaskSelector = config.rangeRightMaskSelector;
  this.rangeLeftMarkerSelector = config.rangeLeftMarkerSelector;
  this.rangeRightMarkerSelector = config.rangeRightMarkerSelector;

  this.video = video;

  this.init();
};

VideoRange.prototype.init = function() {
  $(this.progressControlSelector).append(this.$scriptVideoRangeTemplate.html());
  this.$rangeLeftMask = $(this.rangeLeftMaskSelector);
  this.$rangeRightMask = $(this.rangeRightMaskSelector);
  this.$rangeLeftMarker = $(this.rangeLeftMarkerSelector);
  this.$rangeRightMarker = $(this.rangeRightMarkerSelector);

  this.$rangeLeftMask.on('click', $.proxy(this.jumpToStart, this));
  this.$rangeRightMask.on('click', $.proxy(this.jumpToFinish, this));

  this.video.on('timeupdate', $.proxy(this.onVideoTimeUpdate, this));
  this.video.on('play', $.proxy(this.onVideoPlay, this));
  this.$inputStart.on('keyup', $.proxy(this.updateStart, this));
  this.$inputFinish.on('keyup', $.proxy(this.updateFinish, this));
};

VideoRange.prototype.onVideoTimeUpdate = function(event, currentTime) {
  if (currentTime < this.start) {
    this.video.currentTime(this.start);
  }

  if (currentTime > this.finish) {
    this.video.currentTime(this.finish);
    this.video.pause();
  }
};

VideoRange.prototype.onVideoPlay = function() {
  if (this.video.currentTime() >= this.finish) {
    this.video.currentTime(this.start);
  }
};

VideoRange.prototype.jumpToStart = function() {
  this.video.currentTime(this.start);
};

VideoRange.prototype.jumpToFinish = function() {
  this.video.currentTime(this.finish);
};

VideoRange.prototype.setStart = function(start) {
  this.start = start;

  var percentage = (this.start / this.video.duration() * 100) + '%';
  this.$rangeLeftMask.css('width', percentage);
  this.$rangeLeftMarker.css('left', percentage);
};

VideoRange.prototype.setFinish = function(finish) {
  this.finish = finish;

  var percentage = ((this.video.duration() - this.finish) / this.video.duration() * 100) + '%';
  this.$rangeRightMask.css('width', percentage);
  this.$rangeRightMarker.css('right', percentage);
};

VideoRange.prototype.updateStart = function() {
  var start = TimeDisplay.displayTimeToSecs(this.$inputStart.val());
  this.setStart(start);
};

VideoRange.prototype.updateFinish = function() {
  var finish = TimeDisplay.displayTimeToSecs(this.$inputFinish.val());
  this.setFinish(finish);
};
