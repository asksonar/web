class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :track_page_viewed, only: [:index, :new, :show, :edit]

  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) << :full_name
      devise_parameter_sanitizer.for(:account_update) << :full_name
    end

    def track_page_viewed
      if current_researcher.nil?
        Analytics.instance.page_viewed_signed_out(request.remote_ip, request.url)
      else
        Analytics.instance.page_viewed_signed_in(current_researcher, request.url)
      end
    end

end
