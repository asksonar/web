/*
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
*/

$(function() {
  if (sonar.request.controller !== 'highlights') {
    return;
  }

  $('[data-toggle="tooltip"]').tooltip();

  var videoController = new VideoController({
    videoId: 'example_video_1'
  });

  // var videoResize = new VideoResize({
  //   scriptVideoResizeButtonTemplate: $('#video-resize-button-template'),
  //   resizeBtnAfterSelector: '.vjs-fullscreen-control',
  //   resizeBtnSelector: '.vjs-custom-resize-control',
  //   divVideoTranscriptContainer: $('.video-transcript-container')

  // }, videoController);

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

  HighlightTimeline.call(videoTranscript, {
    highlightStart: $('.ctn-highlight-start'),
    highlightFinish: $('.ctn-highlight-finish'),
    checkboxSelector: '.video-check-show',
    checkAll: $('#btn-check-show-all')
  });

  videoTranscript.init();

  // var videoLink = new VideoLink({
  //   inputUrlTime: $('#input-url-time'),
  //   inputUrlBase: $('#input-url-base'),
  //   btnCopyVideoLink: $('#btn-copy-video-link'),
  //   spanTime: $('.span-time')
  // });

  videoController.on('timeupdate', videoTranscript.onTimeupdate);
  // videoController.on('timeupdate', videoLink.onTimeupdate);

  var timeSeconds = new URI(window.location.href).search(true).t || 0;

  videoController.src(sonar.scenarioResult.srcArray);
  // videoController.play(timeSeconds);

  var checkableTranscript = Object.create(modulejs.require('TranscriptElement'));
  CheckableComponent.call(checkableTranscript);
  var checkableNote = Object.create(modulejs.require('NoteElement'));
  CheckableComponent.call(checkableNote);
  var checkableStep = Object.create(modulejs.require('StepElement'));
  CheckableComponent.call(checkableStep);

  var timelineArray = []
    .concat(checkableStep.buildElementArray(sonar.scenarioResult.stepArray))
    .concat(checkableTranscript.buildElementArray(sonar.scenarioResult.transcriptionArray))
    .concat(checkableNote.buildElementArray(sonar.scenarioResult.highlightedArray));

  videoTranscript.buildTranscript(sonar.scenarioResult.hashid, timelineArray);
  videoTranscript.refreshView();

  var videoRange = new VideoRange({
    inputStart: $('#input-video-time-start'),
    inputFinish: $('#input-video-time-end'),
    hiddenStart: $('#scenario_highlight_start_seconds'),
    hiddenFinish: $('#scenario_highlight_end_seconds'),
    scriptVideoRangeTemplate: $('#video-range-template'),
    progressControlSelector: '.vjs-progress-control',
    rangeLeftMaskSelector: '.vjs-custom-range-left-mask',
    rangeRightMaskSelector: '.vjs-custom-range-right-mask',
    rangeMiddleMaskSelector: '.vjs-custom-range-middle-mask',
    rangeLeftMarkerSelector: '.vjs-custom-range-left-marker',
    rangeRightMarkerSelector: '.vjs-custom-range-right-marker'
  }, videoController);

  videoRange.on('videoRangeChange', $.proxy(videoTranscript.onVideoRangeChange, videoTranscript));
  videoRange.on('videoRangeChange', $.proxy(videoTranscript.updateCheckAll, videoTranscript));

  videoRange.init();

  if (sonar.scenarioHighlight) {
    videoTranscript.setChecked(
      sonar.scenarioHighlight.timeline_elements.steps,
      sonar.scenarioHighlight.timeline_elements.notes,
      sonar.scenarioHighlight.timeline_elements.transcripts
    );
  } else {
    videoRange.setStartFinish(parseFloat(timeSeconds), parseFloat(timeSeconds) + 10);
    videoTranscript.setCheckedNotes();
  }

  $(window).load(function() {
    videoTranscript.focusLink(timeSeconds);
  });

  // videoLink.updateShareLink(sonar.scenarioResult.shareLink);

  // $(window).load(function() {
  //   videoTranscript.focusLink(timeSeconds);
  // });

});
