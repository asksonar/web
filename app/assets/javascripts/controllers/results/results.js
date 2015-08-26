$(function(){

  if (!$('#results-show').length) {
    return;
  }

  $('[data-toggle="tooltip"]').tooltip();
  $('[data-toggle="popover"]').popover();

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

  var videoModal = new VideoModal({
    modal: $('#summary_video_container'),
    divUserEmail: $('#ctn-user-email'),
    divStepOrder: $('#ctn-step-order'),
    divStepDescription: $('#ctn-step-description'),
    btnHighlightVideoLink: $('#btn-highlight-video-link')

  }, videoController, videoTranscript, videoLink);

  var resultsView = new ResultsView({
    divAllContent: $('.main-content-wrapper'),
    divMainContent: $('.main-content'),
    btnCopyShareLink: $('#btn-copy-share-link'),
    inputShareLink: $('#input-share-link'),
    btnArchive: $('#btn-archive'),
    btnHeroCopyShareLink: $('#btn-hero-copy-share-link'),
    inputHeroShareLink: $('#input-hero-share-link'),
    panelHero: $('.panel-hero')

  }, videoModal);

  var timeSeconds = new URI(location.href).search(true).t || 0;
  if (sonar.resultStep) {
    videoModal.loaded(timeSeconds, {
      result_step_hashid: sonar.resultStep.hashid,
      delighted_array: sonar.resultStep.delightedArray,
      confused_array: sonar.resultStep.confusedArray,
      highlighted_array: sonar.resultStep.highlightedArray,
      src_array: sonar.resultStep.srcArray,
      transcription_array: sonar.resultStep.transcriptionArray,
      user_email: sonar.resultStep.email,
      step_order: sonar.scenarioStep.stepOrder,
      step_description: sonar.scenarioStep.stepDescription,
      share_link: sonar.resultStep.shareLink
    });

    if (timeSeconds > 0) {
      $(window).load(function() {
        videoTranscript.focusLink(timeSeconds);
      });
    }
  }

});
