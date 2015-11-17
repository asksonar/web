class ResultNotesService
  include Singleton

  def create_from_scenario_result_hashid(scenario_result_hashid:, offset_seconds:, text:)
    scenario_result = ScenarioResult.find_by_hashid(scenario_result_hashid)
    result_note = ResultNote.create(
      scenario_result: scenario_result,
      offset_seconds: offset_seconds,
      text: text
    )

    result_note
  end

  def update_from_hashid(hashid:, offset_seconds:, text:)
    result_note = ResultNote.find_by_hashid!(hashid)
    result_note.update(
      offset_seconds: offset_seconds,
      text: text
    )

    result_note
  end

  def destroy_from_hashid(hashid)
    result_note = ResultNote.find_by_hashid!(hashid)
    result_note.destroy
  end
end
