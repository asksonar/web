function VideoController(config, modal) {
  this.videoId = config.videoId;
  this.modal = modal;
  this.init();
}

VideoController.prototype.init = function() {
  this.eventBus = $({});

  this.video = videojs(this.videoId);

  this.video.on('timeupdate', $.proxy(this.onTimeupdate, this));
  this.video.on('play', $.proxy(this.onPlay, this));
  this.video.on("loadedmetadata", $.proxy(this.onLoadedmetadata, this));
};

VideoController.prototype.on = function(event, callback) {
  this.eventBus.on(event, callback);
};

VideoController.prototype.play = function(timeSeconds) {
  this.currentTime(timeSeconds);
  this.video.userActive(true);
  this.video.play();
};

VideoController.prototype.pause = function() {
  this.video.pause();
};

VideoController.prototype.paused = function() {
  return this.video.paused();
};

VideoController.prototype.src = function(srcArray) {
  this.video.src(srcArray);
  this.video.load();
};

VideoController.prototype.duration = function() {
  return this.video.duration();
};

VideoController.prototype.collapseTimes = function(arrayOfTimeObjects) {
  if (arrayOfTimeObjects) {
    return arrayOfTimeObjects.map(function(object) {
      return object.time;
    });
  } else {
    return [];
  }
};

VideoController.prototype.currentTime = function(timeSeconds) {
  if (isNaN(timeSeconds)) {
    return this.video.currentTime();
  } else {
    return this.video.currentTime(Math.max(timeSeconds, 0));
  }
};

VideoController.prototype.onTimeupdate = function() {
  var currentTime = this.currentTime();
  this.eventBus.trigger('timeupdate', currentTime);
};

VideoController.prototype.onPlay = function() {
  this.eventBus.trigger('play');
};

VideoController.prototype.onLoadedmetadata = function() {
  this.eventBus.trigger('loaded');
};


