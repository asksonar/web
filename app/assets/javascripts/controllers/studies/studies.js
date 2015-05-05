$(function(){

  var APP_ID = 'ifnadmakmckbjjhbnjcjpfeeljhhmgib';
  //var APP_ID = 'neeoccancikpmendfnglomhpeckokjei';

  if (!$('#studies-show').length) {
    return;
  }

  var view = new StudiesView({
    'ctnInstallChrome': $('#ctn-install-chrome'),
    'ctnInstallExtension': $('#ctn-install-extension'),
    'ctnStartFeedback': $('.ctn-study')
  });
  var controller = new StudiesController(view, APP_ID, {
    'btnInstallExtension': $('#btn-install-extension'),
    'btnStartFeedback': $('#btn-start-feedback'),
    'form': $('form')
  });

  controller.refresh();
});
