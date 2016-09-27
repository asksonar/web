require 'airsonar'

class AircraftController < ApplicationController
  before_action :authenticate_user!

  def index
    @prezi = prezi(query_params: query_params, column_params: column_params)

    respond_to do |format|
      format.html
      format.json {
        render json: {
          column_names: @prezi.column_params_selected,
          sort_column: @prezi.sort_column,
          sort_direction: @prezi.sort_direction,
          aircraft_fleet: @prezi.aircraft_fleet_json
        }
      }
    end
  end

  def show
    @prezi = prezi(id: params[:id])
  end

  def update
    airsonar = Airsonar.new()
    options = Hash.new { |h,k| h[k] = Hash.new(&h.default_proc) }
    options[:user] = current_user.email

    update_params.each do |key, value|
      options[:aircraft][key] = value
    end

    airsonar.update_aircraft(params[:aircraft][:msn], params[:aircraft][:aircraft_model], options)
    flash[:info] = '<strong>Your suggestion has been submitted.</strong>'
    redirect_to aircraft_path(params[:id])
  end

  def export
    @prezi = prezi(query_params: query_params, column_params: column_params)

    respond_to do |format|
      format.html { redirect_to aircraft_index_path }
      format.csv { send_data Aircraft.to_csv(@prezi.aircraft_fleet_json, @prezi.column_params_selected) }
    end
  end

  private

  def prezi(query_params: {}, column_params: {}, id: nil)
    AircraftPresenter.new(current_user.company, display_count, sort_column, sort_direction, query_params, column_params, id)
  end

  def display_count
    params[:display_count] || 25
  end

  def sort_column
    sort_column = params.fetch(:sort_params, {}).permit(:sort_column).fetch(:sort_column, {})
    Aircraft.column_names.include?(sort_column) ? sort_column : "msn"
  end

  def sort_direction
    sort_direction = params.fetch(:sort_params, {}).permit(:sort_direction).fetch(:sort_direction, {})
    %w[asc desc].include?(sort_direction) ? sort_direction : "asc"
  end

  def query_params
    # use `fetch` in place of `require` to supply a default when :datatable_filters is not present
    params.fetch(:datatable_filters, {}).permit(
      :msn => [], :aircraft_status => [], :aircraft_manufacturer => [], :aircraft_model => [], :aircraft_type => [],
      :registration => [], :engine_model => [], :engine_variant => [], :operator => [], :operator_country => [],
      :build_year => [], :aircraft_age => [], :seats_configuration => [], :line_number => [], :aircraft_series => [],
      :last_delivery_date => [], :operator_region => []
    )
  end

  def column_params
    # use `fetch` in place of `require` to supply a default when :datatable_columns is not present
    params.fetch(:datatable_columns, {}).permit(:selected => [], :available => [])
  end

  def update_params
    params.fetch(:aircraft, {}).permit(:build_year, :line_number)
  end
end
