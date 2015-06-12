class VideosJsonController < ApplicationController
  def show
    @result_step = ResultStep.find_by(video_params)
    if @result_step.nil?
      render status: 500, plain: "<strong>Error Loading Video</strong> - The video could not be found."
    end

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
    json['delighted_array'] = @result_step.feelings_delighted.map { |feeling| feeling.feeling_at_seconds }
    json['confused_array'] = @result_step.feelings_confused.map { |feeling| feeling.feeling_at_seconds }
    json['highlighted_array'] = @result_step.highlights.map { |highlight| highlight.at_seconds }
    render json: json
  end

  private
    def video_params
      params.permit(:scenario_step_id, :scenario_result_id)
    end
end
