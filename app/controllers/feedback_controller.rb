class FeedbackController < ApplicationController
  before_action :authenticate_researcher!
  PAGE_SIZE = 20

  def index
    @page = params[:page].to_i
    @scenario_results, @has_next = paged_results(@page)
  end

  def show
    @scenario_result = ScenarioResult.find_by_hashid!(params[:id])
    authorize @scenario_result
    @page = query.count_newer_than(@scenario_result, created_by: current_researcher) / PAGE_SIZE
    @scenario_results, @has_next = paged_results(@page)

    render :index
  end

  private

  def query
    @query ||= ScenarioResultsQuery.instance
  end

  # returns a tuple of results and whether or not there is a next page
  def paged_results(page)
    results = query.my_feedback_paged(
      page,
      PAGE_SIZE,
      true,
      created_by: current_researcher
    )

    [results[0, PAGE_SIZE], results.length > PAGE_SIZE]
  end
end
