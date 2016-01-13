$(function(){

  if (!$('#invitations-new').length) {
    return;
  }

  function toggleAdmin(event) {
    var thisEl = $(event.currentTarget);
    var role = this.checked ? 'admin' : 'user';
    var userId = thisEl.attr('data-user-id');
    var url = '/users/' + userId;

    $.ajax({
      type: 'PATCH',
      dataType: 'json',
      url: url,
      data: {
        role: role,
        authenticity_token: AUTH_TOKEN
      },
      success: function(response) {
        if (role === 'admin') {
          notify.info('Admin privilege saved');
        } else {
          notify.info('Admin privilege revoked');
        }
      }.bind(this),
      error: function(jqXHR) {
        notify.error(jqXHR.responseText);
      }.bind(this)
    });
  }

  $('.user-role').on('change', toggleAdmin);

});
