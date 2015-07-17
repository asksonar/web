class ShareVideosController < ApplicationController
  def show
    @video = ResultVideo.find_by_hashid(params[:id])
    @result_step = @video.result_step
    @scenario_step = @video.scenario_step
    @scenario = @scenario_step.scenario
    @user = @video.panelist
  end
end
