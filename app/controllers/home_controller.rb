class HomeController < ApplicationController
  def index
    if researcher_signed_in? && current_researcher.has_v2
      redirect_to trends_path
    elsif researcher_signed_in?
      redirect_to results_path
    else
      redirect_to new_researcher_session_path
    end
  end
end
