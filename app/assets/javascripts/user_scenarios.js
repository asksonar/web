
$(function(){

  $('#div-started-study').hide();

  $('#btn-start').click(function() {

    /*
    var appId = 'neeoccancikpmendfnglomhpeckokjei';
    chrome.runtime.sendMessage(appId, {launchApp: launchAppParams}, function(response) {
      console.log('Response from launching the app: ' + response);
    });
  */

    $.ajax({
      url: '/user/scenarios/new',
      method: 'POST',
      data: $('#form').serialize(),
      dataType: 'json'
    }).done(function(response){
      var launchAppParams = {};
      launchAppParams[response.uuid] = scenarioParams;

      var appId = 'neeoccancikpmendfnglomhpeckokjei';
      chrome.runtime.sendMessage(appId, {launchApp: launchAppParams}, function(response) {
        console.log('Response from launching the app: ' + response);
      });

      $('#div-start-study').hide();
      $('#div-started-study').show();
    });


  });

});