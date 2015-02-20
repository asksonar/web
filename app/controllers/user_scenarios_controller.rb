class UserScenariosController < ApplicationController
  def index
    @user_scenarios = UserScenario.where(user_id: session[:user_id])
  end
end
