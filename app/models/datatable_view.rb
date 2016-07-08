class DatatableView < ActiveRecord::Base
  belongs_to :company

  after_initialize :default_values, unless: :persisted?

  HASHIDS_SALT = 'ZCcyKObjvuEl'

  def default_values
    self.default_view = true if default_view.nil?
    self.name = 'Default view' if name.nil?
    self.datatable_columns = {
      "selected": ["msn", "aircraft_status", "aircraft_manufacturer", "aircraft_model", "airline"],
      "available": [
        "aircraft_version", "registration", "engine_model", "engine_version", "owner", "airline_country",
        "build_year", "aircraft_age", "seats", "mtow", "hours_cumulative", "cycles_cumulative"
      ]
    }.to_json if datatable_columns.nil?
  end
end
