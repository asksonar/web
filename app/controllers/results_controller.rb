class ResultsController < ApplicationController

  def index
    hash = {}
    hash[:company] = current_user.company

    if @owner = params[:owner]
      if @owner == 'me'
        hash[:created_by] = current_user.id
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
    @summary = Scenario.find_by_hashid(params[:id])
  end

end
