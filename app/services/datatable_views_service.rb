class DatatableViewsService
  include Singleton

  def create_datatable_view(company, name, datatable_columns, datatable_filters)
    old_datatable_view=company.datatable_views.where(default_view: true).first()

    new_datatable_view = DatatableView.create(
      company: company,
      name: name,
      datatable_columns: datatable_columns.to_json,
      datatable_filters: datatable_filters.to_json
    )

    update_default_view(old_datatable_view, new_datatable_view)
    new_datatable_view
  end

  def update_datatable_columns(datatable_view, datatable_columns)
    datatable_view.update(datatable_columns: datatable_columns.to_json)
  end

  def get_datatable_columns(datatable_view)
    JSON.parse(datatable_view.datatable_columns)
  end

  def get_datatable_filters(datatable_view)
    JSON.parse(datatable_view.datatable_filters)
  end

  def get_saved_views(company)
    company.datatable_views
  end

  def update_default_view(old_datatable_view, new_datatable_view)
    return if old_datatable_view == new_datatable_view
    old_datatable_view.update(default_view: false)
    new_datatable_view.update(default_view: true)
  end
end
