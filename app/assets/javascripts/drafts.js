/*
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
*/

$(function(){
  $('#main-drafts-index .panel').click(function(){
    window.location.href = $(this).attr('path');
  });

  autosize($('#main-drafts-new textarea, #main-drafts-edit textarea'));

  var recountSteps = function(){
    $('.ctn-step-count').each(function(index){
      $(this).html('Step ' + (index + 1) + '.');
    });
  };

  var emptyStep = {steps:[{}]};
  var newStepTemplate;
  if ($('#new-step-template').length > 0) {
    newStepTemplate = Handlebars.compile($('#new-step-template').html());
    if (scenarioSteps.steps.length > 0) {
      $('#ctn-step-list').html(newStepTemplate(scenarioSteps));
      recountSteps();
    } else {
      $('#ctn-step-list').html(newStepTemplate(emptyStep));
    }
  }

  $('#ctn-step-list').on('click', '.btn-add-step', function(event){
    var ctnStep = $(this).closest('.ctn-step');
    ctnStep.after(newStepTemplate(emptyStep));
    recountSteps();
  });

  $('#ctn-step-list').on('click', '.btn-remove-step', function(event){
    var ctnStep = $(this).closest('.ctn-step');
    ctnStep.remove();
    recountSteps();
  });

});
