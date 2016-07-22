class ChangeTableDatatableViewsUpdateDatatableColumns < ActiveRecord::Migration
  def change
    datatable_views = DatatableView.where(default_view: true)
    datatable_views.each do |datatable_view|
      datatable_view.datatable_columns = {
        "selected": ["msn", "aircraft_status", "aircraft_manufacturer", "aircraft_model", "operator"],
        "available": [
          "aircraft_type", "registration", "engine_model", "engine_variant", "operator_country",
          "build_year", "aircraft_age", "seats_configuration", "line_number", "aircraft_series",
          "last_delivery_date", "operator_region"
        ]
      }.to_json
      datatable_view.save
    end
  end
end
