class DatatableViewsService
  include Singleton

  def create_datatable_view(company, name, datatable_columns, datatable_filters)
    old_datatable_view=company.datatable_views.where(current_view: true).first()

    new_datatable_view = DatatableView.create(
      company: company,
      name: name,
      default_view: false,
      datatable_columns: datatable_columns.to_json,
      datatable_filters: datatable_filters.to_json
    )

    update_current_view(old_datatable_view, new_datatable_view)
    new_datatable_view
  end

  def delete_datatable_view(company, datatable_view)
    new_datatable_view=company.datatable_views.where(default_view: true).first()
    update_current_view(datatable_view, new_datatable_view)
    datatable_view.destroy
  end

  def get_datatable_columns(datatable_view)
    JSON.parse(datatable_view.datatable_columns)
  end

  def get_datatable_filters(datatable_view)
    JSON.parse(datatable_view.datatable_filters)
  end

  def get_saved_views(company)
    company.datatable_views.where.not(default_view: true)
  end

  def update_current_view(old_datatable_view, new_datatable_view)
    return if old_datatable_view == new_datatable_view
    old_datatable_view.update(current_view: false)
    new_datatable_view.update(current_view: true)
  end
end
