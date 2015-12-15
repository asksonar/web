class ResultNotePresenter < SimpleDelegator
  def public_json
    {
      hashid: hashid,
      time: offset_seconds,
      text: text
    }
  end

  def created_by
    if scenario_result.scenario.nil?
      scenario_result.created_by
    else
      scenario_result.scenario.created_by
    end
  end
end
