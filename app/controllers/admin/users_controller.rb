module Admin
  class UsersController < ApplicationController
    before_action :authenticate_user!

    def show
      @company_id = current_user.company_id
      @users = query.users(@company_id).map(&:prezi)
      @invited_users = query.invited_users(@company_id).map(&:prezi)
    end

    def update
      user = User.find_by_id(params[:id])
      service.update_role(user, params[:role])
      render json: { user: user.full_name.nil? ? user.email : user.full_name, role: user.role }
    end

    def destroy
      user = User.find_by_id(params[:id])

      if user.invitation_token.present? && user.invitation_accepted_at.nil?
        user.destroy
        render json: {
          invited_user: { id: user.id },
          notify: "Your invitation was removed"
        }
      else
        user.soft_delete
        render json: {
          user: { id: user.id },
          notify: "Removed " + user.full_name + " from your organization"
        }
      end
    end

    private

    def query
      @query ||= UsersQuery.instance
    end

    def service
      @service ||= UsersService.instance
    end
  end
end
