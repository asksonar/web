$(function(){

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
    divStepOrder: $('#ctn-step-order'),
    divStepDescription: $('#ctn-step-description')
  }, videoController, videoTranscript, videoLink);

  var deleteModal = new DeleteModal({
    modal: $('#delete_confirmation_container'),
    btnDeleteYes: $('#btn-delete-yes'),
    btnDeleteNo: $('#btn-delete-no')
  });

  var resultsView = new ResultsView({
    divAllContent: $('.main-content-wrapper'),
    btnCopyShareLink: $('#btn-copy-share-link'),
    inputShareLink: $('#input-share-link'),
    btnArchive: $('#btn-archive'),
    btnDelete: $('#btn-delete'),
    btnHeroCopyShareLink: $('#btn-hero-copy-share-link'),
    inputHeroShareLink: $('#input-hero-share-link'),
    panelHero: $('.panel-hero'),
  }, videoModal, deleteModal);

  var timeSeconds = new URI(location.href).search(true).t || 0;
  if (sonar.resultStep) {
    videoModal.loaded(timeSeconds, {
      hashid: sonar.resultStep.hashid,
      delightedArray: sonar.resultStep.delightedArray,
      confusedArray: sonar.resultStep.confusedArray,
      highlightedArray: sonar.resultStep.highlightedArray,
      srcArray: sonar.resultStep.srcArray,
      transcriptionArray: sonar.resultStep.transcriptionArray,
      email: sonar.resultStep.email,
      stepOrder: sonar.scenarioStep.stepOrder,
      stepDescription: sonar.scenarioStep.stepDescription,
      shareLink: sonar.resultStep.shareLink
    });
  }

});
