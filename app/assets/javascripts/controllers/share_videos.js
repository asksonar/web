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
  var modal = new VideoModal({
    modal: $(),
    divVideoText: $('#videoText'),
    inputUrlTime: $('#input-url-time'),
    inputUrlBase: $('#input-url-base'),
    divUserEmail: $(),
    divStepOrder: $(),
    divStepDescription: $(),
    btnCopyVideoLink: $('#btn-copy-video-link'),
    btnHighlightVideoLink: $('#btn-highlight-video-link'),
    scriptVideoTextTemplate: $('#video-text-template')
  }, videoController);

  videoController.src(srcArray);
  videoController.play(new URL(window.location.href).search.substring(3));
  modal.$videoText.html(modal.buildTranscript(transcriptionArray));
  modal.$inputUrlBase.attr('data-base-url', shareLink + '?t=');

});
