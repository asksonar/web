class TrendsController < ApplicationController
  before_action :authenticate_researcher!

  def index
    @prezi = prezi(query_params)
    json = @prezi.nps_by_day_json

    respond_to do |format|
      format.html
      format.json {render json: json}
    end
  end

  private

  def prezi(query_params)
    TrendsPresenter.new(current_researcher.company_id, params[:date], query_params)
  end

  def query_params
    params.permit(region: [], country: [])
  end
end
