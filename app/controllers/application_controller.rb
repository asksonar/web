class ApplicationController < ActionController::Base
  include Pundit
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def pundit_user
    current_researcher
  end

  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) << :full_name
      devise_parameter_sanitizer.for(:account_update) << :full_name
    end

  private
    def user_not_authorized(exception)
      raise ActionController::ForbiddenError
    end
end