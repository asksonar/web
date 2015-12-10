class ResponsesJsonController < ApplicationController
  before_action :authenticate_researcher!

  def index
    responseParams = {}
    responseParams[:company] = current_researcher.company
    responseParams[:created_since] = Time.zone.parse(params[:startTime])
    @scenario_results = query
      .responses(responseParams)
      .map(&:prezi)
      .map(&:list_json)

    render json: @scenario_results
  end

  private

  def query
    @query ||= ScenarioResultsQuery.instance
  end
end
