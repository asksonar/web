class HighlightsController < ApplicationController

  def create
    @result_step = ResultStep.find_by_hashid(params[:result_step_hashid])
    StepHighlight.create(
      result_step: @result_step,
      offset_seconds: params[:offset_seconds],
      context_transcription: @result_step.transcription_at(params[:offset_seconds].to_f)
    )

    json = {}
    json['delighted_array'] = @result_step.feelings_delighted.map { |feeling| feeling.feeling_at_seconds }
    json['confused_array'] = @result_step.feelings_confused.map { |feeling| feeling.feeling_at_seconds }
    json['highlighted_array'] = @result_step.highlights.map { |highlight| highlight.offset_seconds }
    render json: json
  end

end
