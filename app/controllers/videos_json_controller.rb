class VideosJsonController < ApplicationController
  def show
    @result_step = ResultStep.find_by_hashid(params[:result_step_hashid])
    if @result_step.nil?
      render status: 500, plain: "<strong>Error Loading Video</strong> - The video could not be found."
      return
    end

    @video = @result_step.video
    if @video.nil?
      render status: 500, plain: "<strong>Error Loading Video</strong> - The video has not yet been uploaded."
      return
    end

    json = {}
    json['result_step_hashid'] = @result_step.hashid
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

    Analytics.instance.result_video_viewed(current_researcher, @result_step.scenario_result.scenario, @result_step, true)
  end

end
