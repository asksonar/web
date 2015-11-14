class ScenarioResultsQuery
  include Singleton

  def my_feedback(current_researcher)
    ScenarioResult.where(created_by: current_researcher)
  end

end
