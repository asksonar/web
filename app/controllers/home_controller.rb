class HomeController < ApplicationController
  def index
    if current_researcher
      redirect_to results_path
    else
      redirect_to new_researcher_session_path
    end
  end
end
