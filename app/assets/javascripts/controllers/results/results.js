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
  });
  var videoModal = new VideoModal({
    modal: $('#summary_video_container'),
    divVideoText: $('#videoText'), // TODO: remove
    inputUrlTime: $('#input-url-time'),
    inputUrlBase: $('#input-url-base'),
    divUserEmail: $('#ctn-user-email'),
    divStepOrder: $('#ctn-step-order'),
    divStepDescription: $('#ctn-step-description'),
    btnCopyVideoLink: $('#btn-copy-video-link'),
    btnHighlightVideoLink: $('#btn-highlight-video-link'),
    scriptVideoTextTemplate: $('#video-text-template'),
    scriptVideoTextPartial: $('#video-text-partial'),
    scriptVideoResizeButton: $('#video-resize-button'),
    btnToggleTranscripts: $('#toggle-transcripts'),
    btnToggleNotes: $('#toggle-notes'),
    divVideoTranscriptContainer: $('.video-transcript-container'),
    btnAddNote: $('#btn-add-note'),
    spanTime: $('.span-time')
  }, videoController, videoTranscript);

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
