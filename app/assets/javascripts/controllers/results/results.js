$(function(){

  if (!$('#results-show').length) {
    return;
  }

  $('[data-toggle="tooltip"]').tooltip();
  $('[data-toggle="popover"]').popover();

  var videoController = new VideoController({
    videoId: 'example_video_1'
  });
  var videoModal = new VideoModal({
    modal: $('#summary_video_container'),
    divVideoText: $('#videoText'),
    inputUrlTime: $('#input-url-time'),
    inputUrlBase: $('#input-url-base'),
    divUserEmail: $('#ctn-user-email'),
    divStepOrder: $('#ctn-step-order'),
    divStepDescription: $('#ctn-step-description'),
    btnCopyVideoLink: $('#btn-copy-video-link'),
    btnHighlightVideoLink: $('#btn-highlight-video-link')
  }, videoController);
  var view = new ResultsView({
    divAllContent: $('.main-content-wrapper'),
    divMainContent: $('.main-content'),
    btnCopyShareLink: $('#btn-copy-share-link'),
    inputShareLink: $('#input-share-link'),
    btnArchive: $('#btn-archive')
  }, videoModal);
});
