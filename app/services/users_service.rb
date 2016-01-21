class UsersService
  include Singleton

  def update_role(user, role)
    user.update_attribute(:role, role)
  end
end
