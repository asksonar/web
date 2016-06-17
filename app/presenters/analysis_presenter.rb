class AnalysisPresenter
  def fleets_query
    @fleets_query ||= FleetsQuery.instance
  end

  def fleets_json
    Fleet.select(
      :id, :aircraft_status, :aircraft_type, :serial_number, :build_year,
      :operator, :aircraft_series, :aircraft_manufacturer, :aircraft_age
    ).to_json
  end

  def fleets_json_pv
    attributes = ["Aircraft Status", "Aircraft Type", "Build Year", "Operator", "Operator Country", "Owner", "Manager", "Engine Type", "Aircraft Series", "Aircraft Manufacturer"]
    input = Fleet.pluck(:aircraft_status, :aircraft_type, :build_year, :operator, :operator_country, :owner, :manager, :engine_type, :aircraft_series, :aircraft_manufacturer)
    input.unshift(attributes)
  end
end
