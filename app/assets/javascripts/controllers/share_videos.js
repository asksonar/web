/*
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
*/

$(function(){
  if (!$('#share_videos-show').length) {
    return;
  }

  $('[data-toggle="tooltip"]').tooltip();

  var videoController = new VideoController({
    videoId: 'example_video_1'
  });

  $('.vjs-control-bar .vjs-fullscreen-control').after($('#video-resize-button').html());

  var videoTranscript = new VideoTranscript({
    divVideoText: $('#videoText'),
    btnToggleTranscripts: $('#toggle-transcripts'),
    btnAddNote: $('#btn-add-note'),
    scriptVideoTextTemplate: $('#video-text-template'),
    scriptVideoTextPartial: $('#video-text-partial')

  }, videoController);

  var videoLink = new VideoLink({
    inputUrlTime: $('#input-url-time'),
    inputUrlBase: $('#input-url-base'),
    btnCopyVideoLink: $('#btn-copy-video-link'),
    spanTime: $('.span-time')
  });

  videoController.on('timeupdate', videoTranscript.onTimeupdate);
  videoController.on('timeupdate', videoLink.onTimeupdate);

  videoController.markers(
    sonar.resultStep.delightedArray,
    sonar.resultStep.confusedArray,
    sonar.resultStep.highlightedArray
  );
  videoController.src(sonar.resultStep.srcArray);
  videoController.play(new URI(location.href).search(true).t || 0);

  videoTranscript.buildTranscript(
    sonar.resultStep.transcriptionArray,
    sonar.resultStep.delightedArray,
    sonar.resultStep.confusedArray,
    sonar.resultStep.highlightedArray
  );
  videoTranscript.refreshView();

  videoLink.updateShareLink(sonar.resultStep.shareLink);

});
