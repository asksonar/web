class HelpsController < ApplicationController
  def show
    @scenario = Scenario.find_by_hashid(params[:study_id])
  end
end
