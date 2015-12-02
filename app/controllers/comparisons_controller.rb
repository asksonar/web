class ComparisonsController < ApplicationController
  def index
    @prezi = prezi(query_params)
  end

  def prezi(query_params)
    ComparisonsPresenter.new('region', query_params)
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
