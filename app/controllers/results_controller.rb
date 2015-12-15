class ResultsController < ApplicationController
  before_action :authenticate_researcher!

  PAGE_SIZE = 20

  def index
    @page = params[:page].to_i
    results = query.results_paged(@page, PAGE_SIZE, true, company: current_researcher.company)
    @results = results[0, PAGE_SIZE].map(&:prezi)
    @has_next = results.length > PAGE_SIZE
  end

  def show
    if !params[:result_id].nil?
      @scenario = Scenario.find_by_hashid!(params[:result_id]).prezi
      @scenario_result = ScenarioResult.find_by_hashid!(params[:id]).prezi
    else
      @scenario = Scenario.find_by_hashid!(params[:id]).prezi
    end

    authorize @scenario
  end

  def update
    @scenario = Scenario.find_by_hashid!(params[:id])
    authorize @scenario

    # we are toggling, so set it to the reverse of whatever it currently is
    if params[:is_on] == 'true'
      service.set_completed(@scenario)
    elsif params[:is_on] == 'false'
      service.set_live(@scenario)
    end

    # we need to generate sample data for the study
    if params[:walkthrough] == 'true'
      scenario_results_service.generate_new_sample_result(@scenario)
    end

    render plain: 'OK'
  end

  def destroy
    @scenario = Scenario.find_by_hashid!(params[:id])
    authorize @scenario

    service.set_deleted(@scenario)

    flash[:info] = '<strong>Your study has been deleted.</strong>'
    render json: { redirect_url: results_path }
  end

  private

  def service
    @service ||= ScenariosService.instance
  end

  def scenario_results_service
    @scenario_results_service ||= ScenarioResultsService.instance
  end

  def query
    @query ||= ScenariosQuery.instance
  end
end
