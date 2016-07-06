class DatatableViewsController < ApplicationController
  before_action :authenticate_user!

  def create
    @prezi = prezi(query_params: query_params, column_params: column_params)
    datatable_view = @prezi.create_datatable_view(params[:name])

    render json: {
      name: datatable_view.name,
      hashid: datatable_view.hashid
    }
  end

  def show
    @prezi = prezi()
    @prezi.update_default_view(params[:id])
    redirect_to fleets_path
  end

  def update
    @prezi = prezi(column_params: column_params)
    @prezi.update_datatable_columns(params[:id])
    render json: { ok: true }
  end

  private

  def prezi(query_params: {}, column_params: {})
    DatatableViewsPresenter.new(current_user.company, query_params: query_params, column_params: column_params)
  end

  def query_params
    params.permit(:datatable_filters => {
      :aircraft_status => [], :aircraft_manufacturer => [], :aircraft_type => [], :aircraft_series => [],
      :aircraft_variant => [], :registration => [], :serial_number => [], :line_number => [], :build_year => [],
      :operator => [], :owner => [], :owner_type => [], :engine_type => [], :engine_variant => [], :seat_total => [],
      :mtow => [], :hours_cumulative => [], :cycles_cumulative => [], :effective_date => [], :aircraft_age => [],
      :original_operator => [], :operated_for => [], :aircraft_usage => [], :aircraft_usage2 => [],
      :minor_variant => [], :operator_area => [], :operator_country => [], :operator_state => [],
      :current_market_value => [], :current_market_lease_rate => [], :financier1 => [], :noise_category => [], :manager => []
    })["datatable_filters"]
  end

  def column_params
    params.permit(:datatable_columns => { :selected => [], :available => [] })["datatable_columns"]
  end
end
