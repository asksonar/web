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
end
