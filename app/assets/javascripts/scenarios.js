$(function(){
  var templateNewStep = $('#divNewSteps').html();

  $('#btnAddNewStep').click(function(event){
    $('#divNewSteps').append(templateNewStep);
  });

  $('#divNewSteps').on('click', '.btnCancelNewStep', function(event){
    $(this).parent().remove();
  });
});
