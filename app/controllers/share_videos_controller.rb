class ShareVideosController < ApplicationController
  def show
    @video = ResultVideo.find(params[:id])
    @scenario_step = @video.scenario_step
    @scenario = @scenario_step.scenario
    @user = @video.user
  end
end
