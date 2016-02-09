$(function() {
  if (!$('#customers-index').length) {
    return;
  }

  $('.user-table').on('click', '.user-line', function() {
    $(this).next('.user-metadata').fadeToggle('fast');
  });

});
