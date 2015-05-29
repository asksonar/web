function VideoController(config, modal) {
  this.videoId = config.videoId;
  this.modal = modal;
  this.init();
}

VideoController.prototype.init = function() {
  this.eventBus = $({});

  this.video = videojs(this.videoId);
  this.video.on('timeupdate', $.proxy(this.onTimeUpdate, this));
}

VideoController.prototype.on = function() {
  this.eventBus.on.call(arguments);
}

VideoController.prototype.play = function(timestamp) {
  if (!isNaN(timestamp)) {
    this.video.currentTime(timestamp);
  }
  this.video.userActive(true);
  this.video.play();
}

VideoController.prototype.pause = function() {
  this.video.pause();
}

VideoController.prototype.src = function(srcArray) {
  this.video.src(srcArray);
}

VideoController.prototype.currentTime = function(currentSeconds) {
  this.video.currentTime(currentSeconds);
}

VideoController.prototype.onTimeUpdate = function() {
  var currentTime = this.video.currentTime();
  this.eventBus.trigger('timeupdate', currentTime);
}
