class ShareVideosController < ApplicationController
  def show
    @result_step = ResultStep.find_by_hashid(params[:id])
    @video = @result_step.video
    @scenario_step = @result_step.scenario_step
    @scenario = @scenario_step.scenario
    @user = @result_step.panelist

    created_by_id = @scenario.created_by.id
    if current_researcher.nil? or current_researcher.id != created_by_id
      Analytics.instance.share_video_viewed(@scenario.created_by, request.remote_ip, @scenario, @result_step)
    end
  end
end
