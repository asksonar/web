class ResultsController < ApplicationController
  before_action :authenticate_researcher!

  attr_writer :service
  attr_writer :query

  def service
    @service ||= ScenariosService.instance
  end

  def query
    @query ||= ScenariosQuery.instance
  end

  def index
    @results = query.results(company_id: current_researcher.company)
  end

  def show
    if !params[:result_id].nil?
      @scenario = Scenario.find_by_hashid(params[:result_id]).prezi
      @result_step = ResultStep.find_by_hashid(params[:id]).prezi
      @scenario_step = @result_step.scenario_step.prezi
    else
      @scenario = Scenario.find_by_hashid(params[:id]).prezi
    end
  end

  def update
    @result = Scenario.find_by_hashid(params[:id])

    # we are toggling, so set it to the reverse of whatever it currently is
    if params[:is_on] == 'true'
      service.set_completed(@result)
    elsif params[:is_on] == 'false'
      service.set_live(@result)
    end

    # we need to generate sample data for the study
    if params[:walkthrough]=='true'
      ScenarioResult.generate_new_sample_result(@result)
    end

    render plain: 'OK'
  end

end
