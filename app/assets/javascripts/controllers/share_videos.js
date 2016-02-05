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

  var videoResize = new VideoResize({
    scriptVideoResizeButtonTemplate: $('#video-resize-button-template'),
    resizeBtnAfterSelector: '.vjs-fullscreen-control',
    resizeBtnSelector: '.vjs-custom-resize-control',
    divVideoTranscriptContainer: $('.video-transcript-container')

  }, videoController);

  var videoTranscript = new VideoTranscript({
    divTranscriptContainer: $('.transcript-container'),
    divVideoText: $('#videoText'),
    btnToggleTranscripts: $('#toggle-transcripts'),
    btnAddNote: $('#btn-add-note'),
    scriptVideoTextTemplate: $('#video-text-template'),
    scriptVideoTextPartial: $('#video-text-partial'),
    timelineBeginning: $('.ctn-timeline-beginning'),
    timelineEnding: $('.ctn-timeline-ending')

  }, videoController);
  videoTranscript.init();

  var videoLink = new VideoLink({
    inputUrlBase: $('#input-url-base'),
    btnCopyVideoLink: $('#btn-copy-video-link'),
    spanTime: $('.span-time')
  });

  videoController.on('timeupdate', videoTranscript.onTimeupdate);
  videoController.on('timeupdate', videoLink.onTimeupdate);

  var timeSeconds = new URI(window.location.href).search(true).t || 0;

  videoController.src(sonar.scenarioResult.srcArray);
  videoController.play(timeSeconds);

  var transcriptElement = modulejs.require('TranscriptElement');
  var noteElement = modulejs.require('NoteElement');
  var stepElement = modulejs.require('StepElement');

  var timelineArray = []
    .concat(stepElement.buildElementArray(sonar.scenarioResult.stepArray))
    .concat(transcriptElement.buildElementArray(sonar.scenarioResult.transcriptionArray))
    .concat(noteElement.buildElementArray(sonar.scenarioResult.highlightedArray));

  videoTranscript.buildTranscript(sonar.scenarioResult.hashid, timelineArray);

  videoTranscript.refreshView();

  videoLink.updateShareLink(sonar.scenarioResult.shareLink);

  $(window).load(function() {
    videoTranscript.focusLink(timeSeconds);
  });

});
