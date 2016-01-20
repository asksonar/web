$(function(){

  if (!$('#users-show').length) {
    return;
  }

  $('.user-list').on('click', '.user-role', toggleAdmin);
  $('.user-list').on('click', '.btn-delete-account', deleteAccount);
  $('.btn-invite-user').on('click', inviteUser);

  var invitedUserTemplate = Handlebars.compile($('#invited-user-template').html());
  var userTemplate = Handlebars.compile($('#user-template').html());

  function addToUserList(data) {
    if (data.user) {
      addUser(data.user);
    }

    if (data.invited_user) {
      addInvitedUser(data.invited_user);
    }
  }

  function addUser(user) {
    var $userTemplate = userTemplate({
      full_name: user.full_name,
      email: user.email,
      is_admin: user.is_admin,
      id: user.id
    });

    $('.table-users tr').last().after($userTemplate);
  }

  function addInvitedUser(user) {
    var $invitedUserTemplate = invitedUserTemplate({
      invited_on: "moments ago",
      email: user.email,
      is_admin: user.is_admin,
      id: user.id });

    if ($('.table-invited-users').hasClass('hidden')) {
      $('.table-invited-users').removeClass('hidden');
      $('.table-invited-users table').append('<tbody>' + $invitedUserTemplate + '</tbody>');
    } else {
      $('.table-invited-users tr').last().after($invitedUserTemplate);
    }
  }

  function removeFromUserList(data) {
    if (data.user) {
      removeUser(data.user);
    }

    if (data.invited_user) {
      removeInvitedUser(data.invited_user);
    }
  }

  function removeUser(user) {
    var deletedUser = $('.user-line a[data-user-id="' + user.id + '"]');
    deletedUser.closest("tr").remove();
  }

  function removeInvitedUser(user) {
    var deletedUser = $('.user-line a[data-user-id="' + user.id + '"]');
    deletedUser.closest("tr").remove();

    if ( $('.table-invited-users tr').length === 0) {
      $('.table-invited-users').addClass('hidden');
    }
  }

  function inviteUser(event) {
    event.preventDefault();
    bsh.removeError($("[name='user[email]']"));

    var email = $( "input[name='user[email]']" ).val();
    var companyId = $( "input[name='user[company_id]']" ).val();
    var role = $('#user-role')[0].checked ? 'admin' : 'user';
    var data = { "user": { "email": email, "company_id": companyId, "role": role } };

    $.ajax({
      type: 'POST',
      dataType: 'json',
      url: '/user/invitation',
      data: $.extend(data, {
        authenticity_token: AUTH_TOKEN
      }),
      success: function(data) {
        $( "input[name='user[email]']" ).val('');
        addToUserList(data);
        notify.info(data.notify);
      },
      error: function(jqXHR) {
        if ( jqXHR.responseJSON ) {
          var errors = jqXHR.responseJSON.errors;

          $.each(errors, function(index, error) {
            if (error === "Email has already been taken") {
              error = "You have already added or invited this user to your organization";
            }

            bsh.addError(
              $("[name='user[email]']"),
              error
            );
          });
        } else {
          notify.error(jqXHR.responseText);
        }
      }
    });
  }

  function deleteAccount (event) {
    var thisEl = $(event.currentTarget);
    var id = thisEl.attr('data-user-id');

    $.ajax({
      type: 'POST',
      url: '/admin/users/',
      data: {
        _method: 'DELETE',
        id: id,
        authenticity_token: AUTH_TOKEN
      },
      success: function(data){
        removeFromUserList(data);
        notify.info(data.notify);
      },
      error: function(jqXHR){
        notify.error(jqXHR.responseText);
      }
    });
  }

  function toggleAdmin(event) {
    var thisEl = $(event.currentTarget);
    var role = this.checked ? 'admin' : 'user';
    var id = thisEl.attr('data-user-id');

    $.ajax({
      type: 'POST',
      dataType: 'json',
      url: '/admin/users/',
      data: {
        _method: 'PATCH',
        role: role,
        id: id,
        authenticity_token: AUTH_TOKEN
      },
      success: function(data) {
        var user = data.user;

        if (data.role === 'admin') {
          notify.info(user + ' is now an admin');
        } else {
          notify.info(user + ' is no longer an admin');
        }
      },
      error: function(jqXHR) {
        notify.error(jqXHR.responseText);
      }
    });
  }
});
