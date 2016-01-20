$(function(){

  if (!$('#users-show').length) {
    return;
  }

  var usersView = new UsersView({
    invitedUserTemplate: $('#invited-user-template'),
    userTemplate: $('#user-template'),
    divUsersTableRows: $('.table-users tr'),
    divInvitedUsersTable: $('.table-invited-users'),
    invitedUsersTable: $('.table-invited-users table')
  });

  var usersController = new UsersController({
    divUserList: $('.user-list'),
    btnInviteUser: $('.btn-invite-user'),
    inputUserEmail: $("input[name='user[email]']"),
    inputUserCompanyId: $( "input[name='user[company_id]']" ),
    divUserRole: $('#user-role')
  }, usersView);

});
