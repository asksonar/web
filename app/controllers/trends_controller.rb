class TrendsController < ApplicationController
  before_action :authenticate_user!

  def index
    @prezi = prezi(query_params)

    respond_to do |format|
      format.html
      format.json { render json: @prezi.nps_by_day_json }
    end
  end

  private

  def prezi(query_params)
    TrendsPresenter.new(current_user.company_id, params[:date], query_params)
  end

  def query_params
    params.permit(region: [], country: [])
  end
end
