class FleetsService
  include Singleton

  def update_datatable_columns(datatable_view, datatable_columns)
    datatable_view.update(datatable_columns: datatable_columns.to_json)
  end

  def get_datatable_columns(datatable_view)
    JSON.parse(datatable_view.datatable_columns)
  end
end
