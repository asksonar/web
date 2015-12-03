class HomeController < ApplicationController
  def index
    if current_researcher && current_researcher.has_v2
      redirect_to trends_path
    elsif current_researcher && current_researcher.has_v1
      redirect_to results_path
    else
      redirect_to new_researcher_session_path
    end
  end
end
