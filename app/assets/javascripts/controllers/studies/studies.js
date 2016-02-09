$(function() {

  if (!$('#studies-show').length) {
    return;
  }

  var extension = new ExtensionController(sonar.chrome_app_id);
  var view = new StudiesView({
    'ctnInstallChrome': $('#ctn-install-chrome'),
    'ctnInstallExtension': $('#ctn-install-extension'),
    'ctnStudy': $('#ctn-study'),
    'ctnStartFeedback': $('#ctn-start-feedback'),
    'ctnRestartFeedback': $('#ctn-restart-feedback')
  });
  var controller = new StudiesController(extension, view, {
    'btnInstallExtension': $('#btn-install-extension'),
    'btnStartFeedback': $('#btn-start-feedback'),
    'form': $('form')
  });

  controller.checkForExtension();
});
