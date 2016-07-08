class FleetsController < ApplicationController
  before_action :authenticate_user!

  def index
    @prezi = prezi(query_params: query_params, column_params: column_params)

    respond_to do |format|
      format.html
      format.json {
        render json: {
          column_names: @prezi.column_params["selected"],
          sort_column: @prezi.sort_column,
          sort_direction: @prezi.sort_direction,
          fleets: @prezi.fleets_json
        }
      }
    end
  end

  def show
    @prezi = prezi(query_params: query_params)
  end

  def export
    @prezi = prezi(query_params: query_params)

    respond_to do |format|
      format.html { redirect_to fleets_path }
      format.csv { send_data Fleet.to_csv(@prezi.fleets) }
    end
  end

  private

  def prezi(query_params: {}, column_params: {})
    FleetsPresenter.new(current_user.company, display_count, sort_column, sort_direction, query_params, column_params)
  end

  def display_count
    params[:display_count] || 25
  end

  def sort_column
    Fleet.column_names.include?(params[:sort_column]) ? params[:sort_column] : "msn"
  end

  def sort_direction
    %w[asc desc].include?(params[:sort_direction]) ? params[:sort_direction] : "asc"
  end

  def query_params
    params.permit(
      :msn => [], :aircraft_status => [], :aircraft_manufacturer => [], :aircraft_model => [], :aircraft_version => [],
      :registration => [], :engine_model => [], :engine_version => [], :airline => [], :owner => [], :airline_country => [],
      :build_year => [], :aircraft_age => [], :seats => [], :mtow => [], :hours_cumulative => [], :cycles_cumulative => []
    )
  end

  def column_params
    params.permit(:selected => [], :available => [])
  end
end
