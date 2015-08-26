class TranscriptsController < ApplicationController

  def update
    @step_transcription = StepTranscription.find_by_hashid(params[:id])

    @step_transcription.update(transcript_update_params)

    @result_step = @step_transcription.result_step

    json = {}
    json['delighted_array'] = @result_step.feelings_delighted.map { |feeling| feeling.feeling_at_seconds }
    json['confused_array'] = @result_step.feelings_confused.map { |feeling| feeling.feeling_at_seconds }
    json['highlighted_array'] = @result_step.highlights.map { |highlight| highlight.offset_seconds }
    render json: json
  end

  private
    def transcript_update_params
      params.permit(:offset_seconds, :text)
    end

end
