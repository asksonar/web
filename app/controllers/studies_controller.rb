class StudiesController < ApplicationController
  def show
    @scenario = Scenario.find_by_hashid(params[:id])
  end

  def new
    @scenario = Scenario.find_by_hashid(arams[:id])
    @user_scenario = ScenarioResult.create(scenario: @scenario);
    render json: {uuid: @user_scenario.uuid}
  end

end
