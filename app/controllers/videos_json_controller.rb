class VideosJsonController < ApplicationController
  def show
    @video = ResultVideo.find_by(video_params)
    if @video.nil?
      render status: 500, plain: "<strong>Error Loading Video</strong> - The video has not yet been uploaded."
      return
    end

    json = @video.as_json
    json['user_email'] = @video.panelist.email
    json['step_description'] = @video.scenario_step.description
    json['step_order'] = @video.scenario_step.step_order
    json['share_link'] = @video.share_link
    json['transcription_array'] = @video.transcription_array
    json['src_array'] = @video.src_array
    render json: json
  end

  private
    def video_params
      params.permit(:scenario_step_id, :scenario_result_id)
    end
end
