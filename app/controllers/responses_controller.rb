class ResponsesController < ApplicationController
  before_action :authenticate_researcher!

  def index
    @scenario_results = query
      .responses(company: current_researcher.company)
      .map(&:prezi)
  end

  private

  def query
    @query ||= ScenarioResultsQuery.instance
  end
end
