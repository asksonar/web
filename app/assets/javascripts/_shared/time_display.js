TimeDisplay = {
  displayTimeToSecs: function(displayTime) {
    var mins = parseInt(displayTime.split(':')[0]);
    var secs = parseInt(displayTime.split(':')[1]);

    return mins * 60 + secs;
  },
  secsToDisplayTime: function(seconds) {
    var mins = Math.floor(seconds / 60);
    var secs = Math.floor(seconds) % 60;

    return mins + ":" + ('00' + secs).slice(-2);
  },
  dateToDisplayTime: function(date) {
    var year = date.getFullYear();
    var month = date.getMonth() + 1;
    var day = date.getDate();
    var hours = date.getHours();
    var minutes = date.getMinutes();
    var seconds = date.getSeconds();
    var milliseconds = date.getMilliseconds();

    return year + "-" + month + "-" + day + " " + hours + ":" + minutes + ":" + seconds + "." + milliseconds;
  }
};
