$(function(){

  if (!$('#invitations-new').length) {
    return;
  }

  $('.user-role').on('change', toggleAdmin);
  $('#delete_with_ajax').on('show.bs.modal', setUserId);
  $('#btn-delete-yes').on('click', deleteUser);

  function toggleAdmin(event) {
    var thisEl = $(event.currentTarget);
    var role = this.checked ? 'admin' : 'user';
    var userId = thisEl.attr('data-user-id');
    var url = '/users/' + userId;

    $.ajax({
      type: 'POST',
      dataType: 'json',
      url: url,
      data: {
        _method: 'PATCH',
        role: role,
        authenticity_token: AUTH_TOKEN
      },
      success: function(data) {
        if (role === 'admin') {
          notify.info('Admin privilege saved');
        } else {
          notify.info('Admin privilege revoked');
        }
      },
      error: function(jqXHR) {
        notify.error(jqXHR.responseText);
      }
    });
  }

  function setUserId (event) {
    var userId = $(event.relatedTarget).data('user-id');
    $(event.currentTarget).find('#btn-delete-yes').attr('data-user-id', userId);
  }

  function deleteUser (event) {
    var userId = $(event.currentTarget).attr('data-user-id');
    var url = '/users/' + userId;

    $.ajax({
      type: 'POST',
      url: url,
      data: {
        _method: 'DELETE',
        authenticity_token: AUTH_TOKEN
      },
      success: function(data){
        var userId = data.userId;
        var deletedUser = $('.user-line a[data-user-id="' + userId + '"]');
        deletedUser.closest("tr").remove();
        notify.info('User account successfully deleted');
      },
      error: function(jqXHR){
        notify.error(jqXHR.responseText);
      }
    });
  }
});
