class HighlightsController < ApplicationController

  def create
    @result_step = ResultStep.find_by(result_step_params)
    @result_video = ResultVideo.find_by(result_step_params)
    StepHighlight.create(
      result_step: @result_step,
      offset_seconds: highlight_params[:offset_seconds]
      context_transcription: @result_step.transcription_at(highlight_params[:offset_seconds].to_f)
    )

    json = {}
    json['delighted_array'] = @result_step.feelings_delighted.map { |feeling| feeling.feeling_at_seconds }
    json['confused_array'] = @result_step.feelings_confused.map { |feeling| feeling.feeling_at_seconds }
    json['highlighted_array'] = @result_step.highlights.map { |highlight| highlight.offset_seconds }
    render json: json
  end

  private
    def highlight_params
      params.permit(:offset_seconds)
    end

    def result_step_params
      params.permit(:scenario_step_id, :scenario_result_id)
    end

end
