class DatatableViewsPresenter
  def initialize(company, query_params: {}, column_params: {})
    @company = company
    @query_params = query_params
    @column_params = column_params
  end

  def create_datatable_view(name)
    datatable_views_service.create_datatable_view(@company, name, @column_params, @query_params)
  end

  def update_current_view(hashid)
    old_datatable_view = @company.datatable_views.where(current_view: true).first()
    new_datatable_view = DatatableView.find_by_hashid(hashid)
    datatable_views_service.update_current_view(old_datatable_view, new_datatable_view)
  end

  def delete_datatable_view(hashid)
    @datatable_view = DatatableView.find_by_hashid(hashid)
    datatable_views_service.delete_datatable_view(@company, @datatable_view)
  end

  private

  def datatable_views_service
    @datatable_views_service ||= DatatableViewsService.instance
  end
end
