class AircraftHistoriesQuery
  include Singleton

  def aircraft_histories(aircraft_hashid)
    aircraft = Aircraft.find_by_hashid!(aircraft_hashid)
    aircraft.aircraft_histories
  end

end
