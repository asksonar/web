class TranscriptsController < ApplicationController
  attr_writer :service

  def service
    @service ||= ResultTranscriptionsService.instance
  end

  def update
    result_transcription = service.update_from_hashid(
      hashid: params[:id],
      offset_seconds: params[:time],
      text: params[:text]
    )

    json = result_transcription.prezi.public_json
    render json: json
  end
end
