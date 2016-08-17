class AnalysisView < ActiveRecord::Base
  belongs_to :company

  after_initialize :default_values, unless: :persisted?

  HASHIDS_SALT = "3ubIBZO4N4q2"

  def default_values
    self.name = "Default view" if name.nil?
    self.default_view = true if default_view.nil?
    self.current_view = true if current_view.nil?
    self.pivot_params = {
      "filtersArray": [],
      "rowArray": ["Aircraft Model"],
      "colArray": ["Aircraft Status"],
      "attrArray": [
        "Aircraft Age", "Aircraft Manufacturer", "Aircraft Series", "Aircraft Type", "Build Year", "Engine Model",
        "Engine Variant", "Operator", "Operator Country", "Operator Region", "Seats Configuration"
      ],
      "filters": {},
      "renderer": { "name": "table", "type": "text" },
      "aggregator": { "name": "count", "params": [] }
    }.to_json if pivot_params.nil?
  end
end
