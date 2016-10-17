class AircraftHistoriesQuery
  include Singleton

  def aircraft_history(hashid)
    AircraftHistory.find_by_hashid!(hashid)
  end

  def aircraft_histories(aircraft_hashid)
    aircraft = Aircraft.find_by_hashid!(aircraft_hashid)
    aircraft.aircraft_histories
  end
end
