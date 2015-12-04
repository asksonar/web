$(function(){

  if (!$('#registrations-edit').length || !$('#registrations-update')) {
    return;
  }
  var deleteModal = new DeleteModal({
    modal: $('#delete_account_confirmation_container'),
    btnDeleteYes: $('#btn-delete-yes'),
    btnDeleteNo: $('#btn-delete-no')
  });

  $('#btn-delete').on('click', function(event) {
    deleteModal.show();
  });

});
