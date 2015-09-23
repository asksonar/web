VideoRange = function(config, video) {
  this.$inputStart = config.inputStart;
  this.$inputFinish = config.inputFinish;

  this.$scriptVideoRangeTemplate = config.scriptVideoRangeTemplate;
  this.progressControlSelector = config.progressControlSelector;
  this.rangeLeftMaskSelector = config.rangeLeftMaskSelector;
  this.rangeRightMaskSelector = config.rangeRightMaskSelector;
  this.rangeLeftMarkerSelector = config.rangeLeftMarkerSelector;
  this.rangeRightMarkerSelector = config.rangeRightMarkerSelector;

  this.minimumRange = 1;

  this.video = video;

  this.init();
};

Eventable.call(VideoRange.prototype);

VideoRange.prototype.init = function() {
  this.$progressControl = $(this.progressControlSelector);
  this.$progressControl.append(this.$scriptVideoRangeTemplate.html());

  this.$rangeLeftMask = $(this.rangeLeftMaskSelector);
  this.$rangeRightMask = $(this.rangeRightMaskSelector);
  this.$rangeLeftMarker = $(this.rangeLeftMarkerSelector);
  this.$rangeRightMarker = $(this.rangeRightMarkerSelector);

  this.$rangeLeftMask.on('click', $.proxy(this.jumpToStart, this));
  this.$rangeRightMask.on('click', $.proxy(this.jumpToFinish, this));

  this.$rangeLeftMarker.draggable({
    axis:'x',
    containment: this.progressControlSelector,
    drag: $.proxy(this.dragStart, this)
  });
  this.$rangeRightMarker.draggable({
    axis:'x',
    containment: this.progressControlSelector,
    drag: $.proxy(this.dragFinish, this)
  });

  this.video.on('timeupdate', $.proxy(this.onVideoTimeUpdate, this));
  this.video.on('play', $.proxy(this.onVideoPlay, this));
  this.$inputStart.on('input', $.proxy(this.inputStart, this));
  this.$inputFinish.on('input', $.proxy(this.inputFinish, this));
};

VideoRange.prototype.onVideoTimeUpdate = function(event, currentTime) {
  if (currentTime < this.start) {
    this.video.currentTime(this.start);
  }

  if (currentTime > this.finish) {
    this.video.pause();
    this.video.currentTime(this.finish);
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
  var left = this.setStartFinish(start, this.finish)[0];
  if (this.video.paused()) {
    this.video.currentTime(this.start);
  }
  this.trigger('videoRangeStartChange', [this.start]);
  this.trigger('videoRangeChange', [this.start, this.finish]);

  return left;
};

VideoRange.prototype.setFinish = function(finish) {
  var left = this.setStartFinish(this.start, finish)[1];
  if (this.video.paused()) {
    this.video.currentTime(this.finish);
  }
  this.trigger('videoRangeFinishChange', [this.finish]);
  this.trigger('videoRangeChange', [this.start, this.finish]);

  return left;
};

VideoRange.prototype.setStartFinish = function(start, finish) {
  this.start = start || 0;
  this.finish = finish || this.video.duration();
  // check bounds
  this.start = Math.max(this.start, 0);
  this.finish = Math.min(this.finish, this.video.duration());
  // start counting minimum range from start
  this.finish = Math.max(this.finish, this.start + this.minimumRange);
  // check finish's upper bound
  this.finish = Math.min(this.finish, this.video.duration());
  // adjust start as needed based on finish's upper bound
  this.start = Math.min(this.start, this.finish - this.minimumRange);
  // check start's lower bound
  this.start = Math.max(this.start, 0);

  this.$inputStart.val(TimeDisplay.secsToDisplayTime(Math.floor(this.start)));
  this.$inputFinish.val(TimeDisplay.secsToDisplayTime(Math.ceil(this.finish)));

  var startWidth = this.start / this.video.duration() * this.$progressControl.width();
  this.$rangeLeftMask.css('width', startWidth);
  this.$rangeLeftMarker.css('left', startWidth);

  var finishWidth = this.finish / this.video.duration() * this.$progressControl.width();
  this.$rangeRightMask.css('width', this.$progressControl.width() - finishWidth);
  this.$rangeRightMarker.css('left', finishWidth);

  return [startWidth, finishWidth];
};

VideoRange.prototype.inputStart = function() {
  if (/\d+:\d\d/.test(this.$inputStart.val())) {
    var start = TimeDisplay.displayTimeToSecs(this.$inputStart.val());
    this.setStart(start);
  }
};

VideoRange.prototype.inputFinish = function() {
  if (/\d+:\d\d/.test(this.$inputFinish.val())) {
    var finish = TimeDisplay.displayTimeToSecs(this.$inputFinish.val());
    this.setFinish(finish);
  }
};

// .1 resolution from dragging
VideoRange.prototype.dragStart = function(event, ui) {
  var percentage = ui.position.left / this.$progressControl.width();
  var startTime = Math.round(percentage * this.video.duration() * 10) / 10;
  var left = this.setStart(startTime);

  ui.position.left = left;
};

// .1 resolution from dragging
VideoRange.prototype.dragFinish = function(event, ui) {
  var percentage = ui.position.left / this.$progressControl.width();
  var finishTime = Math.round(percentage * this.video.duration() * 10) / 10;
  var left = this.setFinish(finishTime);

  ui.position.left = left;
};
