$(function(){

  var walkthroughOverlay = new WalkthroughOverlay({
    topOverlay: $('#top-overlay'),
    leftOverlay: $('#left-overlay'),
    rightOverlay: $('#right-overlay'),
    bottomOverlay: $('#bottom-overlay'),
    padding: 5,

    btnCreate: $('.div-btn-create a'),
    btnTemplate: $('#btn-template-group'),
    btnPublish: $('.btn[name="publish"]'),
    panelHero: $('.panel-hero'),
    linkFirstResult: $('.results-container .video-link').first()
  });

  var walkthroughView = new WalkthroughView({
    start: $('#walkthrough-start'),
    template: $('#walkthrough-template'),
    create: $('#walkthrough-create'),
    share: $('#walkthrough-share'),
    results: $('#walkthrough-results'),
    modal: $('#walkthrough-modal'),
    finish: $('#walkthrough-finish')
  });

  var walkthroughController = new WalkthroughController({
    btnCreate: $('.div-btn-create a'),
    btnTemplate: $('#btn-template-group'),
    btnPublish: $('.btn[name="publish"]'),
    panelHero: $('.panel-hero'),
    btnCopyHero: $('#btn-hero-copy-share-link'),
    linkFirstResult: $('.results-container .video-link').first(),
    modal: $('#summary_video_container')
  }, overlay, walkthroughView);

  walkthroughController.show();

});
