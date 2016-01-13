class ApplicationController < ActionController::Base
  include Pundit
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  def pundit_user
    current_user
  end

  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) << :full_name
      devise_parameter_sanitizer.for(:account_update) << :full_name
      devise_parameter_sanitizer.for(:invite) << [:company_id, :role]
      devise_parameter_sanitizer.for(:accept_invitation) << :full_name
    end

    def authenticate_inviter!
      unless current_user.admin?
        flash[:alert] = "You are not authorized to perform this action."
        redirect_to(request.referrer || root_path)
      end
      super
    end
end
