class FeedbackController < ApplicationController
  attr_writer :query

  def query
    @query ||= ScenarioResultsQuery.instance
  end

  def index
    @scenario_results = query.my_feedback(current_researcher)
  end

  def show
    @scenario_result = ScenarioResult.find_by_hashid(params[:id])
  end
end
