class UserScenariosController < ApplicationController
  def index
    @scenario = Scenario.find_by(uuid: params[:id])
  end

  def new
    @scenario = Scenario.find_by(uuid: params[:id])
    @user_scenario = UserScenario.create(scenario: @scenario);
    render json: {uuid: @user_scenario.uuid}
  end

end
