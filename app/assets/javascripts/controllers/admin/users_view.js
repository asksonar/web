function UsersView(config) {
  this.$divUsersTable = config.divUsersTable;
  this.$divInvitedUsersTable = config.divInvitedUsersTable;
  this.$invitedUsersTable = config.invitedUsersTable;
  this.$invitedUserTemplate = Handlebars.compile(config.invitedUserTemplate.html());
  this.$userTemplate = Handlebars.compile(config.userTemplate.html());
}

UsersView.prototype.addToUserList = function(data) {
  if (data.user) {
    this.addUser(data.user);
  }

  if (data.invited_user) {
    this.addInvitedUser(data.invited_user);
  }
};

UsersView.prototype.addUser = function(user) {
  var $userTemplate = this.$userTemplate({
    full_name: user.full_name,
    email: user.email,
    is_admin: user.is_admin,
    id: user.id
  });

  this.$divUsersTable.find('tr').last().after($userTemplate);
};

UsersView.prototype.addInvitedUser = function(user) {
  var $invitedUserTemplate = this.$invitedUserTemplate({
    invited_on: "moments ago",
    email: user.email,
    is_admin: user.is_admin,
    id: user.id });

  if (this.$divInvitedUsersTable.hasClass('hidden')) {
    this.$divInvitedUsersTable.removeClass('hidden');
    this.$invitedUsersTable.append('<tbody>' + $invitedUserTemplate + '</tbody>');
  } else {
    this.$divInvitedUsersTable.find('tr').last().after($invitedUserTemplate);
  }
};

UsersView.prototype.removeFromUserList = function(data) {
  if (data.user) {
    this.removeUser(data.user);
  }

  if (data.invited_user) {
    this.removeInvitedUser(data.invited_user);
  }
};

UsersView.prototype.removeUser = function(user) {
  var deletedUser = $('.user-line a[data-user-id="' + user.id + '"]');
  deletedUser.closest("tr").remove();
};

UsersView.prototype.removeInvitedUser = function(user) {
  var deletedUser = $('.user-line a[data-user-id="' + user.id + '"]');
  deletedUser.closest("tr").remove();

  if ( this.$divInvitedUsersTable.find('tr').length === 0) {
    this.$divInvitedUsersTable.addClass('hidden');
  }
};
