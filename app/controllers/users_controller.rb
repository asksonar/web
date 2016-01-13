class UsersController < ApplicationController
  before_action :authenticate_user!

  def update
    user = User.find_by_id(params[:id])
    service.update(user, user_params)

    render json: { ok: true }
  end

  private

  def user_params
    {
      role: params[:role]
    }
  end

  def service
    @service ||= UsersService.instance
  end
end
