class VideosJsonController < ApplicationController
  after_action :track_modal_video_viewed, only: :show

  def show
    @result_step = ResultStep.find_by_hashid(params[:result_step_hashid])
    if @result_step.nil?
      return render status: 500, plain: '<strong>Error Loading Video</strong> - The video could not be found.'
    end

    json = @result_step.prezi.public_json
    render json: json
  end

  def track_modal_video_viewed
    Analytics.instance.modal_video_viewed(current_researcher, request.remote_ip, @result_step)
  end
end
