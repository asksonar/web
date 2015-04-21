$(function(){

  var APP_ID = 'ifnadmakmckbjjhbnjcjpfeeljhhmgib';

  if (!$('#studies-show').length) {
    return;
  }

  var view = new StudiesView({
    'ctnInstallChrome': $('#ctn-install-chrome'),
    'ctnInstallExtension': $('#ctn-install-extension'),
    'ctnStartFeedback': $('.ctn-study')
  });
  var controller = new StudiesController(view, "https://chrome.google.com/webstore/detail/" + APP_ID, {
    'btnInstallExtension': $('#btn-install-extension'),
    'btnStartFeedback': $('#btn-start-feedback')
  });

  controller.refresh();

  $('#btn-start-feedback').click(function() {

    /*
    var appId = 'neeoccancikpmendfnglomhpeckokjei';
    chrome.runtime.sendMessage(appId, {launchApp: launchAppParams}, function(response) {
      console.log('Response from launching the app: ' + response);
    });
  */

    $.ajax({
      url: '/studies',
      method: 'POST',
      data: $('form').serialize(),
      dataType: 'json'
    }).done(function(response){
      var launchAppParams = {};
      launchAppParams[response.hashid] = scenarioParams;

      chrome.runtime.sendMessage(APP_ID, {launchApp: launchAppParams}, function(response) {
        console.log('Response from launching the app: ' + response);
      });

      $('#div-start-study').hide();
      $('#div-started-study').show();
    });


  });

});
