/*
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
*/

$(function(){
  if (sonar.request.controller !== 'drafts' || sonar.request.action === 'index') {
    return;
  }

  var recountSteps = function() {
    $('.ctn-count').each(function(index){
      $(this).html((index + 1) + '.');
    });
    autosize($('textarea'));
  };

  var resetPlaceholders = function() {
    $('.ctn-description').each(function(index){
      if (index === 0) {
        return;
      } else if (index % 2 === 0) {
        $(this).find('textarea').attr('placeholder', 'Do that...');
      } else {
        $(this).find('textarea').attr('placeholder', 'Do this...');
      }
    });
  };

  var addStepErrors = function() {
    $('.ctn-step').each(function(step_index){
      var thisEl = $(this);
      var errors = sonar.scenario.steps[step_index].errors;
      $.each(Object.keys(errors), function(key_index, key) {
        bsh.addError(
          thisEl.find($("[name='scenario_steps[][" + key + "]']")),
          errors[key]
        );
      });
    });
  };

  var deleteModal = new DeleteModal({
    modal: $('#delete_with_ajax'),
    btnDeleteYes: $('#btn-delete-yes')
  });

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
    addStepErrors();
  } else {
    $('#ctn-step-list').html(
      newStepTemplate({steps: [{description_placeholder: 'Look here...', url_placeholder: 'www.example.com'}]}) +
      newStepTemplate({steps: [{description_placeholder: 'Do this...', url_placeholder: 'URL (optional)'}]}) +
      newStepTemplate({steps: [{description_placeholder: 'Do that...', url_placeholder: 'URL (optional)'}]})
    );
    recountSteps();
  }

  $('#ctn-step-list').on('click', '.btn-add-step', function(event){
    var ctnStep = $(this).closest('.ctn-step');
    ctnStep.after(newStepTemplate({steps: [{url_placeholder: 'URL (optional)'}]}));
    resetPlaceholders();
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
