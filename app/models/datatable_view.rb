class DatatableView < ActiveRecord::Base
  belongs_to :company

  after_initialize :default_values, unless: :persisted?

  HASHIDS_SALT = 'ZCcyKObjvuEl'

  def default_values
    self.default_view = true if default_view.nil?
    self.name = 'My saved view' if name.nil?
    self.datatable_columns = {
      "selected": ["serial_number", "aircraft_status", "aircraft_manufacturer", "aircraft_type", "operator"],
      "available": ["engine_type", "manager", "owner", "operator_country"]
    }.to_json if datatable_columns.nil?
  end
end
