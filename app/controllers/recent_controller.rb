class RecentController < ApplicationController
  before_action :authenticate_user!

  def index
    @scenario_results = query
                        .responses(response_params)
                        .map(&:prezi)

    respond_to do |format|
      format.html
      format.json { render json: @scenario_results.map(&:list_json) }
    end
  end

  private

  def query
    @query ||= ScenarioResultsQuery.instance
  end

  def response_params
    {
      company: current_user.company,
      created_since: (Time.zone.parse(params[:startTime]) if params[:startTime])
    }
  end
end
