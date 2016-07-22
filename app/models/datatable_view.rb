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
      "selected": ["msn", "aircraft_status", "aircraft_manufacturer", "aircraft_model", "operator"],
      "available": [
        "aircraft_type", "registration", "engine_model", "engine_variant", "operator_country",
        "build_year", "aircraft_age", "seats_configuration", "line_number", "aircraft_series",
        "last_delivery_date", "operator_region"
      ]
    }.to_json if datatable_columns.nil?
  end
end
