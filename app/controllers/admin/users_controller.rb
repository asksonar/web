module Admin
  class UsersController < ApplicationController
    before_action :authenticate_user!

    def show
      @company_id = current_user.company_id
      @users = User.where(company_id: @company_id, deleted_at: nil).order(email: :asc).map(&:prezi)
    end

    def update
      user = User.find_by_id(params[:id])
      service.update_role(user, params[:role])

      render json: { ok: true }
    end

    def destroy
      user = User.find_by_id(params[:id])
      user.soft_delete

      render json: { id: user.id }
    end

    private

    def service
      @service ||= UsersService.instance
    end
  end
end