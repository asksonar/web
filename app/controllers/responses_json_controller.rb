class ResponsesJsonController < ApplicationController
  before_action :authenticate_user!

  def index
    responseParams = {}
    responseParams[:company] = current_user.company
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
