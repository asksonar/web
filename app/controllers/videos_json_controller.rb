class VideosJsonController < ApplicationController
  def show
    @result_step = ResultStep.find_by(video_params)
    if @result_step.nil?
      render status: 500, plain: "<strong>Error Loading Video</strong> - The video could not be found."
    end

    @video = @result_step.video
    if @video.nil?
      render status: 500, plain: "<strong>Error Loading Video</strong> - The video has not yet been uploaded."
      return
    end

    json = @video.as_json
    json['src_array'] = @video.src_array
    json['share_link'] = @result_step.share_link
    json['user_email'] = @result_step.panelist.email
    json['step_description'] = @result_step.scenario_step.description
    json['step_order'] = @result_step.scenario_step.step_order
    json['transcription_array'] = @result_step.transcription_array
    json['delighted_array'] = @result_step.feelings_delighted.map { |feeling| feeling.feeling_at_seconds }
    json['confused_array'] = @result_step.feelings_confused.map { |feeling| feeling.feeling_at_seconds }
    json['highlighted_array'] = @result_step.highlights.map { |highlight| highlight.offset_seconds }
    render json: json
  end

  private
    def video_params
      params.permit(:scenario_step_id, :scenario_result_id)
    end
end
