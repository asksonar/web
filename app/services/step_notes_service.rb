class StepNotesService
  include Singleton

  def create_from_result_step_hashid(result_step_hashid:, offset_seconds:, text:)
    result_step = ResultStep.find_by_hashid(result_step_hashid)
    step_note = StepNote.create(
      result_step: result_step,
      offset_seconds: offset_seconds,
      text: text
    )

    step_note
  end

  def update_from_hashid(hashid:, offset_seconds:, text:)
    step_note = StepNote.find_by_hashid(hashid)
    step_note.update(
      offset_seconds: offset_seconds,
      text: text
    )

    step_note
  end

  def destroy_from_hashid(hashid)
    step_note = StepNote.find_by_hashid(hashid)
    step_note.destroy
  end
end
