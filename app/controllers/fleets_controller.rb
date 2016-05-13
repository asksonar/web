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
    FleetsPresenter.new(params[:display_count], query_params)
  end

  def query_params
    params.permit(:main_filter, aircraft_status: [], aircraft_manufacturer: [], aircraft_type: [], aircraft_series: [], aircraft_variant: [], registration: [], serial_number: [], line_number: [], build_year: [], operator: [], owner: [], owner_type: [], engine_type: [], engine_variant: [], seat_total: [], mtow: [], hours_cumulative: [], cycles_cumulative: [], effective_date: [], aircraft_age: [], original_operator: [], operated_for: [], aircraft_usage: [], aircraft_usage2: [], minor_variant: [], operator_area: [], operator_country: [], operator_state: [], current_market_value: [], current_market_lease_rate: [], financier1: [], noise_category: [], manager: [])
  end
end
