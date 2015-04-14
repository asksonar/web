class ShareVideosController < ApplicationController
  def show
    @video = ResultVideo.find_by_hashid(params[:id])
    @scenario_step = @video.scenario_step
    @scenario = @scenario_step.scenario
    @user = @video.user
  end
end
