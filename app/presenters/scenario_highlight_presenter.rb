class ScenarioHighlightPresenter < SimpleDelegator
  def public_json
    {
      hashid: hashid,
      title: title,
      start_seconds: start_seconds,
      end_seconds: end_seconds,
      timeline_elements: JSON.parse(timeline_elements)
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
