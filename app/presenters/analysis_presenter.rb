class AnalysisPresenter
  def fleets_json
    attributes = ["Aircraft Status", "Aircraft Type", "Build Year", "Operator", "Operator Country", "Owner", "Manager", "Engine Type", "Aircraft Series", "Aircraft Manufacturer"]
    input = Fleet.pluck(:aircraft_status, :aircraft_type, :build_year, :operator, :operator_country, :owner, :manager, :engine_type, :aircraft_series, :aircraft_manufacturer)
    input.unshift(attributes)
  end
end
