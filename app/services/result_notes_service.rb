class ResultNotesService
  include Singleton

  def create(scenario_result, note_params)
    result_note = ResultNote.create(
      scenario_result: scenario_result,
      offset_seconds: note_params[:offset_seconds],
      text: note_params[:text]
    )

    result_note
  end

  def update(result_note, note_params)
    result_note.update(
      offset_seconds: note_params[:offset_seconds],
      text: note_params[:text]
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
