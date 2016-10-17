class DatatableViewsController < ApplicationController
  before_action :authenticate_user!

  def create
    datatable_view = datatable_views_service.create_datatable_view(
      current_user.company,
      params[:name],
      column_params,
      query_params
    )

    render json: {
      name: datatable_view.name,
      hashid: datatable_view.hashid
    }
  end

  def show
    old_datatable_view = current_user.company.datatable_views.where(current_view: true).first()
    new_datatable_view = DatatableView.find_by_hashid(params[:id])
    datatable_views_service.update_current_view(old_datatable_view, new_datatable_view)

    redirect_to aircraft_index_path
  end

  def destroy
    datatable_view = DatatableView.find_by_hashid(params[:id])
    datatable_views_service.delete_datatable_view(current_user.company, datatable_view)

    flash[:info] = '<strong>Your view has been deleted.</strong>'
    render json: { redirect_url: aircraft_index_path }
  end

  private

  def datatable_views_service
    @datatable_views_service ||= DatatableViewsService.instance
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
