class ChangeTableDatatableViewsUpdateDatatableColumnsV2 < ActiveRecord::Migration
  def change
    datatable_views = DatatableView.where(default_view: true)
    datatable_views.each do |datatable_view|
      datatable_view.datatable_columns = {
        "selected": [
          "registration", "aircraft_status", "aircraft_manufacturer", "aircraft_model", "aircraft_type",
          "engine_model", "build_year",  "operator", "operator_region"
        ],
        "available": [
          "msn", "engine_variant", "operator_country", "aircraft_age", "seats_configuration",
          "line_number", "aircraft_series", "last_delivery_date",
        ]
      }.to_json
      datatable_view.save
    end
  end
end
