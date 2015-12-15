class ResultNotesService
  include Singleton

  def create(scenario_result, offset_seconds:, text:)
    result_note = ResultNote.create(
      scenario_result: scenario_result,
      offset_seconds: offset_seconds,
      text: text
    )

    result_note
  end

  def update(result_note, offset_seconds:, text:)
    result_note.update(
      offset_seconds: offset_seconds,
      text: text
    )

    result_note
  end

  def destroy(result_note)
    result_note.destroy
  end

  def create_from_params(params, scenario_result)
    params.each do |note|
      scenario_result.result_notes.create(note)
    end
    scenario_result.result_notes
  end
end
