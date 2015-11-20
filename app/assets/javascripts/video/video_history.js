function VideoHistory() {}

VideoHistory.prototype.loadVideo = function(videoHashId) {
  history.replaceState({}, '', this.getLoadURL(videoHashId));
};

VideoHistory.prototype.unloadVideo = function() {
  history.replaceState({}, '', this.getUnloadURL());
};

function VideoResultsHistory() {}
VideoResultsHistory.prototype = new VideoHistory();
VideoResultsHistory.prototype.constructor = VideoResultsHistory;

VideoResultsHistory.prototype.getLoadURL = function(videoHashId) {
  return '/results/:result_id/videos/:id?t=0'
    .replace(':result_id', sonar.scenario.hashid)
    .replace(':id', videoHashId);
};

VideoResultsHistory.prototype.getUnloadURL = function() {
  return '/results/:id'
    .replace(':id', sonar.scenario.hashid);
};

function VideoFeedbackHistory() {}
VideoFeedbackHistory.prototype = new VideoHistory();
VideoFeedbackHistory.prototype.constructor = VideoFeedbackHistory;

VideoFeedbackHistory.prototype.getLoadURL = function(videoHashId) {
  return '/feedback/videos/:id'
    .replace(':id', videoHashId);
};

VideoFeedbackHistory.prototype.getUnloadURL = function() {
  if (sonar.request.page) { // falsiness covers the zero case for us
    return '/feedback?page=:page'
      .replace(':page', sonar.request.page);
  } else {
    return '/feedback';
  }
};
