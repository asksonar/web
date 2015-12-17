class ComparisonsJsonController < ApplicationController
  before_action :authenticate_researcher!

  def index
    json = prezi(query_params).nps_by_category_json
    render json: json
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
