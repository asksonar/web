$(function(){

  var overlay = new Overlay({
    topOverlay: $('#top-overlay'),
    leftOverlay: $('#left-overlay'),
    rightOverlay: $('#right-overlay'),
    bottomOverlay: $('#bottom-overlay'),
    padding: 5
  });

  var walkthroughView = new WalkthroughView({
    start: $('#walkthrough-start'),
    one: $('#walkthrough-one'),
    oneBee: $('#walkthrough-one-bee'),
    two: $('#walkthrough-two'),
    three: $('#walkthrough-three'),
    threeBee: $('#walkthrough-three-bee'),
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
