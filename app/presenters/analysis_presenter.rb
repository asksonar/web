class AnalysisPresenter
  def attributes
    [
      "MSN", "Aircraft Status", "Aircraft Manufacturer", "Aircraft Model",
      "Aircraft Version", "Registration", "Engine Model", "Engine Version",
      "Airline", "Owner", "Airline Country", "Build Year", "Aircraft Age",
      "Seats", "MTOW", "Hours Cumulative", "Cycles Cumulative"
    ]
  end

  def fleets_json
    input = Fleet.pluck(
      :msn, :aircraft_status, :aircraft_manufacturer, :aircraft_model, :aircraft_version,
      :registration, :engine_model, :engine_version, :airline, :owner, :airline_country,
      :build_year, :aircraft_age, :seats, :mtow, :hours_cumulative, :cycles_cumulative
    )

    input.unshift(attributes)
  end
end
