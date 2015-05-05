class StudiesController < ApplicationController
  def show
    @scenario = Scenario.find_by_hashid(params[:id])
  end

  def create
    @panelist = Panelist.find_by(email: params[:study][:email])
    if @panelist.nil?
      @panelist = Panelist.create(email: params[:study][:email])
    end

    @scenario = Scenario.find_by_hashid(params[:study][:scenario_hashid])
    @user_scenario = ScenarioResult.create(scenario: @scenario, panelist: @panelist)
    render json: {hashid: @user_scenario.hashid}
  end

end
