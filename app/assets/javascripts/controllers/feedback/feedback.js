$(function(){

  if (sonar.request.controller !== 'feedback') {
    return;
  }

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
    spanTime: $('.span-time'),
    hrefLink: $('#btn-create-highlight')
  });

  videoController.on('timeupdate', videoTranscript.onTimeupdate);
  videoController.on('timeupdate', videoLink.onTimeupdate);

  var videoModal = new VideoModal({
    modal: $('#summary_video_container'),
    divUserEmail: $('#ctn-user-email'),
    divTitle: $('.ctn-title')
  }, videoController, videoTranscript, videoLink, new VideoFeedbackHistory());

  var timeSeconds = new URI(location.href).search(true).t || 0;
  if (sonar.scenarioResult) {
    videoModal.loaded(timeSeconds, {
      hashid: sonar.scenarioResult.hashid,
      highlightedArray: sonar.scenarioResult.highlightedArray,
      srcArray: sonar.scenarioResult.srcArray,
      transcriptionArray: sonar.scenarioResult.transcriptionArray,
      email: sonar.scenarioResult.email,
      title: sonar.scenarioResult.title,
      shareLink: sonar.scenarioResult.shareLink
    });
  }

  window.extension = new ExtensionController(sonar.chrome_app_id);
  window.view = new FeedbackView({
    btnRecordFeedback: $('#btn-record-feedback'),
  }, extension, videoModal);

});
