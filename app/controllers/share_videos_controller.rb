class ShareVideosController < ApplicationController
  after_action :track_video_viewed, only: :show

  def show
    if !ScenarioResult.hashids.decode(params[:id])[0].nil?
      @scenario_result = ScenarioResult.find_by_hashid(params[:id])
    else
      result_step = ResultStep.find_by_hashid(params[:id])
      @scenario_result = result_step.scenario_result
    end
    @scenario = @scenario_result.scenario
  end

  def track_video_viewed
    created_by_id = @scenario.created_by.id
    if current_researcher.nil? || current_researcher.id != created_by_id
      Analytics.instance.share_video_viewed(current_researcher, request.remote_ip, @scenario.created_by, @scenario, @scenario_result, false)
    else
      Analytics.instance.result_video_viewed(current_researcher, @scenario, @scenario_result, false)
    end
  end
end
