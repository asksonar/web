class TranscriptsController < ApplicationController
  attr_writer :service

  def service
    @service ||= StepTranscriptionsService.instance
  end

  def update
    step_transcription = service.update_from_hashid(
      hashid: params[:id],
      offset_seconds: params[:time],
      text: params[:text]
    )

    json = step_transcription.prezi.public_json
    render json: json
  end
end
