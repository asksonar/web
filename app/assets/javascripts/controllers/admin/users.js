$(function(){

  if (!$('#users-show').length) {
    return;
  }

  $('.user-table').on('change', '.user-role', toggleAdmin);
  $('#delete_with_ajax').on('show.bs.modal', setUserId);
  $('#btn-delete-yes').on('click', deleteUser);
  $('.btn-invite_user').on('click', inviteUser);

  var newUserTemplate = Handlebars.compile($('#new-user-template').html());

  function inviteUser(event) {
    event.preventDefault();
    var email = $('#user_email').val();
    var company_id = $('#user_company_id').val();
    var role = $('#user_role').is(':checked') ? 'admin' : 'user';
    var data = { "user": { "email": email, "company_id": company_id, "role": role } };
    var url = '/user/invitation';

    $.ajax({
      type: 'POST',
      dataType: 'json',
      url: url,
      data: $.extend(data, {
        authenticity_token: AUTH_TOKEN
      }),
      success: function(data) {
        $('#user_email').val('');
        var id = data.id;
        var is_admin = data.is_admin;
        $( "tr" ).last().after(newUserTemplate({user: [{email: email, is_admin: is_admin, id: id}]}));
        notify.info('An invitation email has been sent to ' + email + '.');
      },
      error: function(jqXHR) {
        if ( jqXHR.responseJSON ) {
          bsh.addError(
            $("[name='user[email]']"),
            jqXHR.responseJSON.errors[0]
          );
        } else {
          notify.error(jqXHR.responseText);
        }
      }
    });
  }

  function toggleAdmin(event) {
    var thisEl = $(event.currentTarget);
    var role = this.checked ? 'admin' : 'user';
    var id = thisEl.attr('data-user-id');
    var url = '/admin/users/';

    $.ajax({
      type: 'POST',
      dataType: 'json',
      url: url,
      data: {
        _method: 'PATCH',
        role: role,
        id: id,
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
    var id = $(event.relatedTarget).data('user-id');
    $(event.currentTarget).find('#btn-delete-yes').attr('data-user-id', id);
  }

  function deleteUser (event) {
    var id = $(event.currentTarget).attr('data-user-id');
    var url = '/admin/users/';

    $.ajax({
      type: 'POST',
      url: url,
      data: {
        _method: 'DELETE',
        id: id,
        authenticity_token: AUTH_TOKEN
      },
      success: function(data){
        var id = data.id;
        var deletedUser = $('.user-line a[data-user-id="' + id + '"]');
        deletedUser.closest("tr").remove();
        notify.info('User account successfully deleted');
      },
      error: function(jqXHR){
        notify.error(jqXHR.responseText);
      }
    });
  }
});
