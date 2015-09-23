/*
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
*/

$(function(){
  if (!$('#highlights-new').length) {
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
    highlightFinish: $('.ctn-highlight-finish')
  });

  // var videoLink = new VideoLink({
  //   inputUrlTime: $('#input-url-time'),
  //   inputUrlBase: $('#input-url-base'),
  //   btnCopyVideoLink: $('#btn-copy-video-link'),
  //   spanTime: $('.span-time')
  // });

  videoController.on('timeupdate', videoTranscript.onTimeupdate);
  // videoController.on('timeupdate', videoLink.onTimeupdate);

  var timeSeconds = new URI(location.href).search(true).t || 0;

  videoController.markers(
    videoController.collapseTimes(sonar.resultStep.delightedArray),
    videoController.collapseTimes(sonar.resultStep.confusedArray),
    videoController.collapseTimes(sonar.resultStep.highlightedArray)
  );
  videoController.src(sonar.resultStep.srcArray);
  // videoController.play(timeSeconds);

  var videoRange = new VideoRange({
    inputStart: $('#input-video-time-start'),
    inputFinish: $('#input-video-time-end'),
    scriptVideoRangeTemplate: $('#video-range-template'),
    progressControlSelector : '.vjs-progress-control',
    rangeLeftMaskSelector: '.vjs-custom-range-left-mask',
    rangeRightMaskSelector: '.vjs-custom-range-right-mask',
    rangeLeftMarkerSelector: '.vjs-custom-range-left-marker',
    rangeRightMarkerSelector: '.vjs-custom-range-right-marker'
  }, videoController);

  videoTranscript.buildTranscript(
    sonar.resultStep.hashid,
    [],
    sonar.resultStep.delightedArray,
    sonar.resultStep.confusedArray,
    sonar.resultStep.highlightedArray
  );
  videoTranscript.refreshView();

  videoRange.on('videoRangeChange', $.proxy(videoTranscript.onVideoRangeChange, videoTranscript));

  // videoLink.updateShareLink(sonar.resultStep.shareLink);

  // $(window).load(function() {
    // videoTranscript.focusLink(timeSeconds);
  // });

  $('.video-check-show').on('click', function() {
    var total = $('.video-check-show').length;
    var checked = $.makeArray($('.video-check-show')).reduce(function(prev, current) {
      return prev + ($(current).prop('checked') ? 1 : 0);
    }, 0);

    if (checked === 0) {
      $('#btn-check-show-all').prop('checked', false);
      $('#btn-check-show-all').prop('indeterminate', false);
    } else if (checked === total) {
      $('#btn-check-show-all').prop('checked', true);
      $('#btn-check-show-all').prop('indeterminate', false);
    } else {
      $('#btn-check-show-all').prop('checked', false);
      $('#btn-check-show-all').prop('indeterminate', true);
    }
  });

  $('#btn-check-show-all').on('click', function() {
    var checked = $('#btn-check-show-all').prop('checked');
    $('.video-check-show').prop('checked', checked);
  });

  window.videoController = videoController;
  window.videoRange = videoRange;
  window.videoTranscript = videoTranscript;

});
