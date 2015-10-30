$(function(){

  if (!$('#studies-show').length) {
    return;
  }

  window.view = new StudiesView({
    'ctnInstallChrome': $('#ctn-install-chrome'),
    'ctnInstallExtension': $('#ctn-install-extension'),
    'ctnStudy': $('#ctn-study'),
    'ctnStartFeedback': $('#ctn-start-feedback'),
    'ctnRestartFeedback': $('#ctn-restart-feedback')
  });
  window.controller = new StudiesController(view, sonar.chrome_app_id, {
    'btnInstallExtension': $('#btn-install-extension'),
    'btnStartFeedback': $('#btn-start-feedback'),
    'form': $('form')
  });

  controller.checkForExtension();
});
