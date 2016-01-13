class UsersService
  include Singleton

  def update(user, user_params)
    user.role = user_params[:role]
    user.save(validate: false)
  end
end
