/*
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
*/

$(function(){
  if (!$('#share_videos-show').length) {
    return;
  }

  loadVideoTranscript(transcriptionArray);

  function loadVideoTranscript (transcriptionArray) {
    var time, text, mins, secs;
    var videoTranscript = '';

    for(var i = 0; i  < transcriptionArray.length; i++) {
      time = transcriptionArray[i].offset
      text = transcriptionArray[i].text.trim();

      mins = Math.floor(time / 60);
      secs = time % 60;

      videoTranscript += "<a class='videoTextLink' data-timestamp='" + time + "'>"
        + mins + ":" + ('00' + secs).slice(-2) + " "
        + text + "</a><br/>";
    }

    var video = videojs('example_video_1', {}, function(){
      this.src(srcArray);
      this.currentTime(new URL(window.location.href).search.substring(3));
      this.userActive(true);
      this.play();
    });

    $('#videoText').html(videoTranscript);
  }

  if (document.getElementById('example_video_1')) {
    videojs('example_video_1').ready(function(){
      this.on('timeupdate', function(){
        var currentTime = this.currentTime();
        var currentSeconds = parseInt(currentTime);

        $('#input-url-time').val(Math.floor(currentSeconds / 60) + ':' + ('00' + currentSeconds % 60).slice(-2));
        $('#input-url-base').val($('#input-url-base').attr('data-base-url') + currentSeconds);
        //console.log(currentTime);
        var videoTextLinks = $('#videoText .videoTextLink').removeClass('activeVideoTextLink');
        var videoTextLink;
        for(var i = videoTextLinks.length - 1; i >= 0; i-- ) {
          videoTextLink = $(videoTextLinks[i]);
          if (videoTextLink.attr('data-timestamp') <= currentTime) {
            videoTextLink.addClass('activeVideoTextLink');
            break;
          }
        }
      });
    });
  }

  $('#videoText').on('click', '.videoTextLink', function() {
    var video = videojs('example_video_1');
    video.currentTime($(this).attr('data-timestamp'));
    video.userActive(true);
    video.play();
  });

  $('#btn-archive, #btn-copy-share-link, #btn-preview, #btn-copy-video-link, #btn-highlight-video-link').tooltip();

  new ZeroClipboard(document.getElementById("btn-copy-video-link")).on( "copy", function (event) {
    event.clipboardData.setData( "text/plain", $('#input-url-base').val());
  });

  $('.modal').on('click', '#input-url-base', function() {
    this.setSelectionRange(0, this.value.length);
  });

  $('#input-url-base').attr('data-base-url', window.location.origin + shareLink + '?t=');

});
