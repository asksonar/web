/*
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
*/

$(function(){
  if (!$('#responses-index').length) {
    return;
  }

  var updateInterval = 30000;
  var newResponses = newResponses || {responses:[{}]};
  var newResponseTemplate = Handlebars.compile($('#new-response-template').html());

  var updateResponses = function() {
    var endTime = new Date();
    var startTime = new Date(endTime - updateInterval);

    $.ajax({
      type: 'GET',
      url: '/responses.json/' + TimeDisplay.dateToDisplayTime(startTime)
    })
      .success(function(data){
        newResponses.responses = data;
        if (data.length === 1) {
          $('.response-alert').text('Show ' + data.length + ' new response');
          $('.response-alert').slideDown();
        }else if (data.length > 1) {
          $('.response-alert').text('Show ' + data.length + ' new response');
          $('.response-alert').slideDown();
        }
       })
      .fail(function(jqXHR){
        notify.error(jqXHR.responseText);
      });
  }

  $('.response-alert').on('click', function(){
    $('.response-alert').slideUp();
    $('.response-alert').after(newResponseTemplate(newResponses));
  })

  setInterval(updateResponses, updateInterval);
});
