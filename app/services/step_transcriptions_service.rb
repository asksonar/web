class StepTranscriptionsService
  include Singleton

  def update_from_hashid(hashid:, offset_seconds:, text:)
    step_transcription = StepTranscription.find_by_hashid(hashid)
    step_transcription.update(
      offset_seconds: offset_seconds,
      text: text
    )

    step_transcription
  end
end
