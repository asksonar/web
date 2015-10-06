class StepTranscriptionsService
  include Singleton

  def update_from_hashid(hashid:, offset_seconds:, text:)
    step_transcription = StepTranscription.find_by_hashid(hashid)

    step_transcription.original_text ||= step_transcription.text
    step_transcription.offset_seconds = offset_seconds
    step_transcription.text = text
    step_transcription.save

    update_first_transcription(result_step)

    # result_step = step_transcription.result_step
    # first_transcription = result_step.step_transcriptions.first
    # if first_transcription == step_transcription
    #   result_step.first_transcription = first_transcription.text
    #   result_step.save
    # end

    step_transcription
  end

  def create(params, result_step)
    params.each do |transcription|
      result_step.step_transcriptions.create(transcription)
    end

    update_first_transcription(result_step)

    result_step.step_transcriptions
  end

  def update_first_transcription(result_step)
    first_transcription = result_step.step_transcriptions.first
    return if first_transcription.nil?
    result_step.first_transcription = first_transcription.text
    result_step.save
  end
end
