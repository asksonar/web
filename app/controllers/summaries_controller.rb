class SummariesController < ApplicationController
  def index
    @scenarios = Scenario.where(company: current_user.company).where("user_count >= 1")
  end

  def index
    hash = {}
    hash[:company] = current_user.company
    if @status = params[:status] then hash[:status] = Scenario.statuses[@status] end
    if @owner = params[:owner]
      if @owner == 'me'
        hash[:created_by] = current_user.id
      else
        hash[:created_by] = params[:owner]
      end
    end

    @scenarios = Scenario.where(hash)
  end

  def my_index
    params[:owner] = 'me'
    index
    render :index
  end

  def show
    @summary = Summary.new(Scenario.find(params[:id]))
  end
end
