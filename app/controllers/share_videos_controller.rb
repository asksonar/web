class ShareVideosController < ApplicationController
  def show
    @result_step = ResultStep.find_by_hashid(params[:id])
    @video = @result_step.video
    @scenario_step = @result_step.scenario_step
    @scenario = @scenario_step.scenario
    @user = @result_step.panelist
  end
end
