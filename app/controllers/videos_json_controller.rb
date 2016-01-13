class VideosJsonController < ApplicationController
  def show
    @scenario_result = ScenarioResult.find_by_hashid(params[:scenario_result_hashid])
    if @scenario_result.nil?
      return render status: 500, plain: '<strong>Error Loading Video</strong> - The video could not be found.'
    end

    json = @scenario_result.prezi.public_json
    render json: json

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
                           true)
  end
end
