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
    hash = {}
    hash[:company] = current_researcher.company

    if @owner = params[:owner]
      if @owner == 'me'
        hash[:created_by] = current_researcher.id
      else
        hash[:created_by] = params[:owner]
      end
    end

    @results = query.results(hash)
  end

  def my_index
    params[:owner] = 'me'
    index
    render :index
  end

  def show
    if !params[:result_id].nil?
      @scenario = Scenario.find_by_hashid(params[:result_id]).prezi
      @result_step = ResultStep.find_by_hashid(params[:id]).prezi
      @scenario_step = @result_step.scenario_step.prezi
    elsif !params[:my_result_id].nil?
      @scenario = Scenario.find_by_hashid(params[:my_result_id]).prezi
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
