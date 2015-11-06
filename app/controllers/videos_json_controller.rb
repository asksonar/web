class VideosJsonController < ApplicationController
  after_action :track_modal_video_viewed, only: :show

  def show
    @scenario_result = ScenarioResult.find_by_hashid(params[:scenario_result_hashid])
    if @scenario_result.nil?
      return render status: 500, plain: '<strong>Error Loading Video</strong> - The video could not be found.'
    end

    json = @scenario_result.prezi.public_json
    render json: json
  end

  def track_modal_video_viewed
    Analytics.instance.modal_video_viewed(current_researcher, request.remote_ip, @scenario_result)
  end
end
