class FleetsController < ApplicationController
  before_action :authenticate_user!

  def index
    @prezi = prezi(query_params)

    respond_to do |format|
      format.html
      format.json {
        render json: {
          sub_filters: @prezi.sub_filters,
          fleets: @prezi.fleets
        }.to_json
      }
    end
  end

  private

  def prezi(query_params)
    FleetsPresenter.new(params[:display_count] || 25, query_params)
  end

  def query_params
    params.permit(:main_filter, :sub_filter)
  end
end
