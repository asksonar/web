class ResultsController < ApplicationController
  before_action :authenticate_researcher!

  PAGE_SIZE = 20

  def index
    @results = query.results_paged(params[:page].to_i, PAGE_SIZE, company: current_researcher.company).map(&:prezi)
  end

  def show
    if !params[:result_id].nil?
      @scenario = Scenario.find_by_hashid!(params[:result_id]).prezi
      @scenario_result = ScenarioResult.find_by_hashid!(params[:id]).prezi
    else
      @scenario = Scenario.find_by_hashid!(params[:id]).prezi
    end
  end

  def update
    @result = Scenario.find_by_hashid!(params[:id])

    # we are toggling, so set it to the reverse of whatever it currently is
    if params[:is_on] == 'true'
      service.set_completed(@result)
    elsif params[:is_on] == 'false'
      service.set_live(@result)
    end

    # we need to generate sample data for the study
    if params[:walkthrough] == 'true'
      scenario_results_service.generate_new_sample_result(@result)
    end

    render plain: 'OK'
  end

  def destroy
    @result = Scenario.find_by_hashid!(params[:id])
    service.set_deleted(@result)

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
