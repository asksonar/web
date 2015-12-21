$(function(){
  if (!$('#users-index').length) {
    return;
  }

  $('.user-table').on('click', '.user-line', function() {
    // $('.user-table .user-metadata').hide();
    $(this).next('.user-metadata').toggle();
  });

});
