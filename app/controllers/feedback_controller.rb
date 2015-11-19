class FeedbackController < ApplicationController
  PAGE_SIZE = 20

  def index
    @scenario_results = paged_results(params[:page].to_i)
  end

  def show
    @scenario_result = ScenarioResult.find_by_hashid!(params[:id])

    @page = query.count_newer_than(@scenario_result) / PAGE_SIZE
    @scenario_results = paged_results(@page)

    render :index
  end

  private

  def query
    @query ||= ScenarioResultsQuery.instance
  end

  def paged_results(page)
    query.my_feedback_paged(
      page,
      PAGE_SIZE,
      created_by: current_researcher
    )
  end
end
