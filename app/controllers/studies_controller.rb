class StudiesController < ApplicationController
  def show
    @scenario = Scenario.find_by_hashid(params[:id])
  end

  def create
    @scenario = Scenario.find_by_hashid(params[:study][:scenario_hashid])

    if !@scenario.live?
      render status: 500, plain: 'This study is no longer active.'
      return
    end

    @panelist = Panelist.find_by(email: params[:study][:email])
    if @panelist.nil?
      @panelist = Panelist.create(email: params[:study][:email])
    end

    @user_scenario = ScenarioResult.create(scenario: @scenario, panelist: @panelist)
    render json: {hashid: @user_scenario.hashid}
  end

end
