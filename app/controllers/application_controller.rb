class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
    if session[:researcher_id]
      @current_user ||= CurrentUser.new(Researcher.find(session[:researcher_id]))
    elsif session[:user_id]
      @current_user ||= CurrentUser.new(User.find(session[:user_id]))
    end
  end

  def drafts_count
    Scenario.drafts(current_user.id).count
  end

  helper_method :current_user
  helper_method :drafts_count
end
