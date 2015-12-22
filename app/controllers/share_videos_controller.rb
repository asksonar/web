class ShareVideosController < ApplicationController

  def show
    if !ScenarioResult.hashids.decode(params[:id])[0].nil?
      @scenario_result = ScenarioResult.find_by_hashid!(params[:id])
    else
      result_step = ResultStep.find_by_hashid!(params[:id])
      @scenario_result = result_step.scenario_result
    end
    @scenario_result = @scenario_result.prezi
    track_video_viewed
  end

  private

  def analytics
    @analytics ||= Analytics.instance
  end

  def track_video_viewed
    analytics.video_viewed(current_user,
      request.remote_ip,
      @scenario_result.scenario,
      @scenario_result,
      false
    )
  end
end
