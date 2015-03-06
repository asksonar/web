/*
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
*/

$(function(){

  $('.templateHasLinks').hover(function(){
    $(this).find('.templateTitle').parent().stop(true).slideUp();
  }, function(){
    $(this).find('.templateTitle').parent().slideDown();
  });

  $('.templateHasLinks').click(function(){
    $(this).find('.templateTitle').parent().finish().slideUp();
  });

  $('.templateCustomPanel').click(function(){
    window.location.href = '/create/new?template=custom';
  });

  var templateNewStep = $('#emptyNewStep').html();

  $('#btnAddNewStep').click(function(event){
    $('#newStepContainer').append(templateNewStep);
  });

  // TODO: fix this
  $('#btnSaveDraft').click(function(){
    $.ajax({
      url: '/scenarios',
      type: 'POST'
    }).done(function(response){
      $('#scenario_id').val(response.id);
    });
  });

  // TODO: fix this
  var validate = function() {

  };

  // TODO: fix this
  $('#btnPublish').click(function(){
    validate();
    form.submit();
  });

});
