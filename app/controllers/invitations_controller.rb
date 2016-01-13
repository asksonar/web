class InvitationsController < Devise::InvitationsController
  def new
    @company_id = current_user.company_id
    @users ||= User.where(company_id: @company_id, deleted_at: nil).order(email: :asc)
    super
  end
end
