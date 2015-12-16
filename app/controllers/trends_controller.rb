class TrendsController < ApplicationController
  before_action :authenticate_researcher!

  def index
    @prezi = prezi(query_params)
  end

  def update
    json = prezi(query_params).nps_by_day_json
    render json: json
  end

  private

  def prezi(query_params)
    TrendsPresenter.new(current_researcher.company_id, params[:date], query_params)
  end

  def query_params
    params.permit(region: [], country: [])
  end
end
