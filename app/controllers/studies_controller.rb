class StudiesController < ApplicationController
  def show
    @scenario = Scenario.find_by_hashid(params[:id])
  end

  def create
    @scenario = Scenario.find_by_hashid(params[:study][:scenario_hashid])
    @user_scenario = ScenarioResult.create(scenario: @scenario);
    render json: {hashid: @user_scenario.hashid}
  end

end
