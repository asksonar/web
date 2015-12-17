class ComparisonsController < ApplicationController
  before_action :authenticate_researcher!

  def index
    @prezi = prezi(query_params)
    json = @prezi.nps_by_category_json

    respond_to do |format|
      format.html
      format.json {render json: json}
    end
  end

  private

  def category
    params[:category] || 'region'
  end

  def prezi(query_params)
    ComparisonsPresenter.new(current_researcher.company_id, category, params[:date], query_params)
  end

  def query_params
    params.permit(region: [], country: [])
  end
end
