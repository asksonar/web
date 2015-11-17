class ShareVideosController < ApplicationController

  def show
    if !ScenarioResult.hashids.decode(params[:id])[0].nil?
      @scenario_result = ScenarioResult.find_by_hashid!(params[:id])
    else
      result_step = ResultStep.find_by_hashid!(params[:id])
      @scenario_result = result_step.scenario_result
    end
    track_video_viewed
  end

  private

  def analytics
    @analytics ||= Analytics.instance
  end

  def track_video_viewed
    scenario = @scenario_result.scenario
    created_by = (scenario || @scenario_result).created_by
    if current_researcher.nil? || current_researcher.id != created_by.id
      share_video_viewed(created_by, scenario)
    else
      result_video_viewed(scenario)
    end
  end

  def share_video_viewed(created_by, scenario)
    analytics.share_video_viewed(current_researcher, request.remote_ip, created_by, scenario, @scenario_result, false)
  end

  def result_video_viewed(scenario)
    analytics.result_video_viewed(current_researcher, scenario, @scenario_result, false)
  end
end
