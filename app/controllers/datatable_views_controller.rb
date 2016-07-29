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
    @prezi.update_current_view(params[:id])
    redirect_to fleets_path
  end

  def destroy
    @prezi = prezi()
    @prezi.delete_datatable_view(params[:id])

    flash[:info] = '<strong>Your view has been deleted.</strong>'
    render json: { redirect_url: fleets_path }
  end

  private

  def prezi(query_params: {}, column_params: {})
    DatatableViewsPresenter.new(current_user.company, query_params, column_params)
  end

  def query_params
    params.fetch(:datatable_filters, {}).permit(
      :msn => [], :aircraft_status => [], :aircraft_manufacturer => [], :aircraft_model => [], :aircraft_type => [],
      :registration => [], :engine_model => [], :engine_variant => [], :operator => [], :operator_country => [],
      :build_year => [], :aircraft_age => [], :seats_configuration => [], :line_number => [], :aircraft_series => [],
      :last_delivery_date => [], :operator_region => []
    )
  end

  def column_params
    params.fetch(:datatable_columns, {}).permit(:selected => [], :available => [])
  end
end
