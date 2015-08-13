class ShareVideosController < ApplicationController
  def show
    @result_step = ResultStep.find_by_hashid(params[:id])
    @video = @result_step.video
    @scenario_step = @result_step.scenario_step
    @scenario = @scenario_step.scenario
    @user = @result_step.panelist

    created_by_id = @scenario.created_by.id
    if current_researcher.nil? or current_researcher.id != created_by_id
      Analytics.instance.share_video_viewed(current_researcher, request.remote_ip, @scenario.created_by, @scenario, @result_step)
    else
      Analytics.instance.result_video_viewed(current_researcher, @scenario, @result_step, false)
    end
  end
end
