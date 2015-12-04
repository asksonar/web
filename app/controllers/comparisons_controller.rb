class ComparisonsController < ApplicationController
  before_action :authenticate_researcher!

  def index
    @prezi = prezi(query_params)
  end

  private

  def prezi(query_params)
    ComparisonsPresenter.new(current_researcher.company_id, 'region', query_params)
  end

  # can handle a query like
  # # /trends?country=United+States&region=New+Jersey
  # or
  # /trends?country=United+States&region[]=New+Jersey&region[]=California
  # or
  # /trends?country[]=United+States&region[]=New+Jersey&region[]=California
  def query_params
    params.permit(:comparison, :country, country: [])
  end
end
