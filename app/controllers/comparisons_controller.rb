class ComparisonsController < ApplicationController
  before_action :authenticate_user!

  def index
    @prezi = prezi(query_params)

    respond_to do |format|
      format.html
      format.json {render json: @prezi.nps_by_category_json}
    end
  end

  private

  def category
    params[:category] || 'region'
  end

  def prezi(query_params)
    ComparisonsPresenter.new(current_user.company_id, category, params[:date], query_params)
  end

  def query_params
    params.permit(region: [], country: [])
  end
end
