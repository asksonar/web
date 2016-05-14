class HomeController < ApplicationController
  def index
    if user_signed_in? && current_user.has_v3
      redirect_to aircrafts_path
    elsif user_signed_in? && current_user.has_v2
      redirect_to dashboard_path
    elsif user_signed_in?
      redirect_to results_path
    else
      redirect_to new_user_session_path
    end
  end
end
