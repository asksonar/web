class StepTranscriptionsService
  include Singleton

  def update_from_hashid(hashid:, offset_seconds:, text:)
    step_transcription = StepTranscription.find_by_hashid(hashid)

    step_transcription.original_text ||= step_transcription.text
    step_transcription.offset_seconds = offset_seconds
    step_transcription.text = text
    step_transcription.save

    step_transcription
  end

  def create(params, result_step)
    params.each do |transcription|
      result_step.step_transcriptions.create(transcription)
    end

    result_step.step_transcriptions
  end
end
