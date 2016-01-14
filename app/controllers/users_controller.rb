class UsersController < ApplicationController
  before_action :authenticate_user!

  def update
    user = User.find_by_id(params[:id])
    service.update_role(user, params[:role])

    render json: { ok: true }
  end

  def destroy
    user = User.find_by_id(params[:id])
    user.soft_delete

    render json: { userId: user.id }
  end

  private

  def service
    @service ||= UsersService.instance
  end
end
