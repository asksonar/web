class ResultsController < ApplicationController
  before_action :authenticate_researcher!

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

    @results = Scenario.results(hash)
  end

  def my_index
    params[:owner] = 'me'
    index
    render :index
  end

  def show
    if params[:result_id].nil?
      @scenario = Scenario.find_by_hashid(params[:id])
    else
      @scenario = Scenario.find_by_hashid(params[:result_id])
      @result_step = ResultStep.find_by_hashid(params[:id])
    end
  end

  def update
    @results = Scenario.find_by_hashid(params[:id])

    # we are toggling, so set it to the reverse of whatever it currently is
    if params[:is_on] == 'true'
      @results.set_completed()
    elsif params[:is_on] == 'false'
      @results.set_live()
    end

    # we need to generate sample data for the study
    if params[:walkthrough]=='true'
      ScenarioResult.generate_new_sample_result(@results)
    end

    render plain: 'OK'
  end

end
