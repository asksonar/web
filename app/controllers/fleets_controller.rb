class FleetsController < ApplicationController
  before_action :authenticate_user!

  def index
    @prezi = prezi(query_params)

    respond_to do |format|
      format.html
      format.json {
        render json: {
          fleets: @prezi.fleets_json,
          result_count: @prezi.result_count
        }
      }
    end
  end

  def show
    @prezi = prezi(query_params)
  end

  def sub_filters
    @prezi = prezi(query_params)
    render json: @prezi.sub_filters
  end

  def export
    @prezi = prezi(query_params)

    respond_to do |format|
      format.html { redirect_to fleets_path }
      format.csv { send_data Fleet.to_csv(@prezi.fleets) }
    end
  end

  private

  def prezi(query_params)
    FleetsPresenter.new(display_count, sort_column, sort_direction, query_params)
  end

  def display_count
    params[:display_count] || 25
  end

  def sort_column
    Fleet.column_names.include?(params[:sort]) ? params[:sort] : "serial_number"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  def query_params
    params.permit(:id, :main_filter, aircraft_status: [], aircraft_manufacturer: [], aircraft_type: [], aircraft_series: [], aircraft_variant: [], registration: [], serial_number: [], line_number: [], build_year: [], operator: [], owner: [], owner_type: [], engine_type: [], engine_variant: [], seat_total: [], mtow: [], hours_cumulative: [], cycles_cumulative: [], effective_date: [], aircraft_age: [], original_operator: [], operated_for: [], aircraft_usage: [], aircraft_usage2: [], minor_variant: [], operator_area: [], operator_country: [], operator_state: [], current_market_value: [], current_market_lease_rate: [], financier1: [], noise_category: [], manager: [])
  end
end
