/* globals bsh */

function UsersController(config, usersView) {
  this.$divUserList = config.divUserList;
  this.$btnInviteUser = config.btnInviteUser;
  this.$inputUserEmail = config.inputUserEmail;
  this.$inputUserCompanyId = config.inputUserCompanyId;
  this.$divUserRole = config.divUserRole;

  this.usersView = usersView;

  this.init();
}

UsersController.prototype.init = function() {
  this.$divUserList.on('click', '.user-role', $.proxy(this.toggleAdmin, this));
  this.$divUserList.on('click', '.btn-delete-account', $.proxy(this.deleteAccount, this));
  this.$btnInviteUser.on('click', $.proxy(this.inviteUser, this));
};

UsersController.prototype.inviteUser = function(event) {
  event.preventDefault();
  bsh.removeError(this.$inputUserEmail);

  var email = this.$inputUserEmail.val();
  var companyId = this.$inputUserCompanyId.val();
  var role = this.$divUserRole[0].checked ? 'admin' : 'user';
  var data = { "user": { "email": email, "company_id": companyId, "role": role } };

  $.ajax({
    type: 'POST',
    dataType: 'json',
    url: '/user/invitation',
    data: $.extend(data, {
      authenticity_token: AUTH_TOKEN
    }),
    success: function(data) {
      this.$inputUserEmail.val('');
      this.usersView.addToUserList(data);
      notify.info(data.notify);
    }.bind(this),
    error: function(jqXHR) {
      if ( jqXHR.responseJSON ) {
        var errors = jqXHR.responseJSON.errors;

        $.each(errors, function(index, error) {
          bsh.addError(
            this.$inputUserEmail,
            error
          );
        }.bind(this));
      } else {
        notify.error(jqXHR.responseText);
      }
    }.bind(this)
  });
};

UsersController.prototype.deleteAccount = function(event) {
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
      this.usersView.removeFromUserList(data);
      notify.info(data.notify);
    }.bind(this),
    error: function(jqXHR){
      notify.error(jqXHR.responseText);
    }.bind(this)
  });
};

UsersController.prototype.toggleAdmin = function(event) {
  var thisEl = $(event.currentTarget);
  var role = thisEl[0].checked ? 'admin' : 'user';
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
    }.bind(this),
    error: function(jqXHR) {
      notify.error(jqXHR.responseText);
    }.bind(this)
  });
};
