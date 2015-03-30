/*
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
*/

$(function(){
  if ($('#main-share_videos-show').length == 0) {
    return;
  }

  loadVideoTranscript(videoJSON);

  function loadVideoTranscript (videoJSON) {
    var videoTranscript = '';
    for(var time in videoJSON) {
      mins = Math.floor(time / 60);
      secs = time % 60;

      videoTranscript += "<a class='videoTextLink' data-timestamp='" + time + "'>"
        + mins + ":" + ('00' + secs).slice(-2) + " "
        + videoJSON[time] + "</a><br/>";
    }

    $('#videoText').html(videoTranscript);
  }

});
