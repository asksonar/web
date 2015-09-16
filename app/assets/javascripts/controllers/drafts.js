/*
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
*/

$(function(){
  if (!$('#drafts-new, #drafts-edit').length) {
    return;
  }

  var recountSteps = function(){
    $('.ctn-count').each(function(index){
      $(this).html((index + 1) + '.');
    });
    autosize($('textarea'));
  };

  var emptyStep = {steps:[{}]};
  var newStepTemplate = Handlebars.compile($('#new-step-template').html());

  if (sonar.template) {
    $('#scenario_title').val(sonar.template.title);
    $('#scenario_description').val(sonar.template.description);
    $('#ctn-step-list').html(newStepTemplate(sonar.template));
    recountSteps();
  } else if (sonar.scenario.steps.length > 0) {
    $('#ctn-step-list').html(newStepTemplate(sonar.scenario));
    recountSteps();
  } else {
    $('#ctn-step-list').html(newStepTemplate(emptyStep));
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

  autosize($('textarea'));

  $('[data-toggle="tooltip"]').tooltip();

});
