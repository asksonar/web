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
    @scenario = Scenario.find_by_hashid(params[:id])
  end

  def update
    @results = Scenario.find_by_hashid(params[:id])
    if params[:is_on]
      @results.status = :completed
    else
      @results.status = :live
    end
    @results.save()

    render plain: 'OK'
  end

end
