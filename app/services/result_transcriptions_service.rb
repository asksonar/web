class ResultTranscriptionsService
  include Singleton

  def update_from_hashid(hashid:, offset_seconds:, text:)
    result_transcription = ResultTranscription.find_by_hashid(hashid)

    result_transcription.original_text ||= result_transcription.text
    result_transcription.offset_seconds = offset_seconds
    result_transcription.text = text
    result_transcription.save

    result_transcription
  end

  def create(params, scenario_result)
    params.each do |transcription|
      scenario_result.result_transcriptions.create(transcription)
    end

    scenario_result.result_transcriptions
  end
end
