VideoHistory = function() {

};

VideoHistory.prototype.loadVideo = function(videoHashId) {
  if (location.href.indexOf('videos') < 0) {
    var newUrl = URI(location.href).segment('videos').segment(videoHashId).addSearch("t", 0);
    history.replaceState({}, '', newUrl);
  }
};

VideoHistory.prototype.unloadVideo = function() {
  var newUrl = URI(location.href).path();
  newUrl = newUrl.substring(0, newUrl.indexOf('/videos/'));
  history.replaceState({}, '', newUrl);
};
