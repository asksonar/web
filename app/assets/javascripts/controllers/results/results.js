$(function(){

  if (!$('#results-show').length) {
    return;
  }

  $('[data-toggle="tooltip"]').tooltip();
  $('[data-toggle="popover"]').popover();

  var videoController = new VideoController({
    videoId: 'example_video_1'
  });

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

  var videoModal = new VideoModal({
    modal: $('#summary_video_container'),
    divUserEmail: $('#ctn-user-email'),
    divStepOrder: $('#ctn-step-order'),
    divStepDescription: $('#ctn-step-description'),
    btnHighlightVideoLink: $('#btn-highlight-video-link'),
    scriptVideoResizeButton: $('#video-resize-button'),
    divVideoTranscriptContainer: $('.video-transcript-container')

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

  sonar.videoModal = videoModal;

});
