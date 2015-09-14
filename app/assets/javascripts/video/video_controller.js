function VideoController(config, modal) {
  this.videoId = config.videoId;
  this.modal = modal;
  this.init();
}

VideoController.prototype.init = function() {
  this.eventBus = $({});

  this.video = videojs(this.videoId);
  this.video.markers({
    markerStyle: {
      'width':'7px',
      'border-radius': '30%',
      'background-color': 'black'
    },
    markerTip:{
      display: true,
      text: function(marker) {
        return marker.text;
      }
    },
    breakOverlay:{
      display: false
    },
    onMarkerReached: function(marker) {},
    markers: []
  });

  this.video.on('timeupdate', $.proxy(this.onTimeUpdate, this));
  // videojs-markers will load the markers from options {} above upon loadedmetadata
  // so we will then load our own markers after that point
  this.video.on("loadedmetadata", $.proxy(this.loadMarkers, this));
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

VideoController.prototype.src = function(srcArray) {
  this.video.src(srcArray);
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

VideoController.prototype.markers = function(arrayDelightedTimes, arrayConfusedTimes, arrayHighlightedTimes) {
  this.arrayDelightedTimes = arrayDelightedTimes || [];
  this.arrayConfusedTimes = arrayConfusedTimes || [];
  this.arrayHighlightedTimes = arrayHighlightedTimes || [];
};

VideoController.prototype.loadMarkers = function() {
  this.video.markers.removeAll();
  if (this.arrayDelightedTimes) {
    this.video.markers.add(this.arrayDelightedTimes.map(function(time) {
      return {
        time: time,
        text: ":)",
        class: 'background-delighted'
      };
    }));
  }

  if (this.arrayConfusedTimes) {
    this.video.markers.add(this.arrayConfusedTimes.map(function(time) {
      return {
        time: time,
        text: ":(",
        class: 'background-confused'
      };
    }));
  }

  if (this.arrayHighlightedTimes) {
    this.video.markers.add(this.arrayHighlightedTimes.map(function(time) {
      return {
        time: time,
        text: "*",
        class: 'background-highlighted'
      };
    }));
  }
};

VideoController.prototype.currentTime = function(timeSeconds) {
  if (isNaN(timeSeconds)) {
    return this.video.currentTime();
  } else {
    return this.video.currentTime(Math.max(timeSeconds, 0));
  }
};

VideoController.prototype.onTimeUpdate = function() {
  var currentTime = this.currentTime();
  this.eventBus.trigger('timeupdate', currentTime);
};
