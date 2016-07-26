class DatatableView < ActiveRecord::Base
  belongs_to :company

  after_initialize :default_values, unless: :persisted?

  HASHIDS_SALT = 'ZCcyKObjvuEl'

  def default_values
    self.default_view = true if default_view.nil?
    self.name = 'Default view' if name.nil?
    self.current_view = true if current_view.nil?
    self.datatable_filters = {} if datatable_filters.nil?
    self.datatable_columns = {
      "selected": [
        "registration", "aircraft_status", "aircraft_manufacturer", "aircraft_model", "aircraft_type",
        "engine_model", "build_year",  "operator", "operator_region"
      ],
      "available": [
        "msn", "engine_variant", "operator_country", "aircraft_age", "seats_configuration",
        "line_number", "aircraft_series", "last_delivery_date",
      ]
    }.to_json if datatable_columns.nil?
  end
end
