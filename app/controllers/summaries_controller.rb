class SummariesController < ApplicationController
  def index
    @summaries = Scenario.joins(:scenario_result).where(company: current_user.company).where("user_count >= 1")
  end

  def show
    @scenario = Scenario.find(params[:id])
    @scenario_result = ScenarioResult.find_by(scenario: @scenario)
    @summary = Summary.new(@scenario, @scenario_result)
  end
end
