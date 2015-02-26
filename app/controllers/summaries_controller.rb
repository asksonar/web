class SummariesController < ApplicationController
  def index
    @scenarios = Scenario.where(company: current_user.company).where("user_count >= 1")
  end

  def show
    @summary = Summary.new(Scenario.find(params[:id]))
  end
end
