class ExplorePresenter
  def fleets_query
    @fleets_query ||= FleetsQuery.instance
  end

  def fleets_json
    Fleet.select(
      :id, :aircraft_status, :aircraft_type, :serial_number, :build_year,
      :operator, :aircraft_series, :aircraft_manufacturer, :aircraft_age
    ).to_json
  end
end
