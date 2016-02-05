window.TimeDisplay = {
  displayTimeToSecs: function(displayTime) {
    var mins = parseInt(displayTime.split(':')[0]);
    var secs = parseInt(displayTime.split(':')[1]);

    return mins * 60 + secs;
  },
  secsToDisplayTime: function(seconds) {
    var mins = Math.floor(seconds / 60);
    var secs = Math.floor(seconds) % 60;

    return mins + ":" + ('00' + secs).slice(-2);
  }
};
