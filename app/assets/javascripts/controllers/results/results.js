$(function() {

  if (!$('#results-show').length) {
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
    spanTime: $('.span-time'),
    hrefLink: $('#btn-create-highlight')
  });

  videoController.on('timeupdate', videoTranscript.onTimeupdate);
  videoController.on('timeupdate', videoLink.onTimeupdate);

  var videoModal = new VideoModal({
    modal: $('#summary_video_container'),
    divUserEmail: $('#ctn-user-email'),
    divTitle: $('.ctn-title')
  }, videoController, videoTranscript, videoLink, new VideoResultsHistory());

  var deleteModal = new DeleteModal({
    modal: $('#delete-with-ajax'),
    btnDeleteYes: $('#btn-delete-yes')
  });

  var resultsView = new ResultsView({
    divAllContent: $('.main-content-wrapper'),
    btnCopyShareLink: $('#btn-copy-share-link'),
    inputShareLink: $('#input-share-link'),
    btnArchive: $('#btn-archive'),
    btnHeroCopyShareLink: $('#btn-hero-copy-share-link'),
    inputHeroShareLink: $('#input-hero-share-link'),
    panelHero: $('.panel-hero'),
    resultPanelToggle: $('.result-panel-toggle')
  }, videoModal, deleteModal);

  var timeSeconds = new URI(window.location.href).search(true).t || 0;
  if (sonar.scenarioResult) {
    videoModal.loaded(timeSeconds, {
      hashid: sonar.scenarioResult.hashid,
      highlightedArray: sonar.scenarioResult.highlightedArray,
      srcArray: sonar.scenarioResult.srcArray,
      transcriptionArray: sonar.scenarioResult.transcriptionArray,
      stepArray: sonar.scenarioResult.stepArray,
      email: sonar.scenarioResult.email,
      title: sonar.scenarioResult.title,
      shareLink: sonar.scenarioResult.shareLink
    });
  }

});
