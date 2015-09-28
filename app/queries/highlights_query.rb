class HighlightsQuery
  include Singleton

  def find_by_hashid(hashid)
    ScenarioHighlight.find_by_hashid(hashid)
  end
end
