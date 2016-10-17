class AircraftHistoryPresenter

  def initialize(id, aircraft_id)
    @id = id
    @aircraft_id = aircraft_id
  end

  def aircraft
    @aircraft ||= aircraft_query.aircraft(@aircraft_id)
  end

  def aircraft_history
    @aircraft_histories ||= aircraft_histories_query.aircraft_history(@id)
  end

  private

  def aircraft_query
    @aircraft_query ||= AircraftQuery.instance
  end

  def aircraft_histories_query
    @aircraft_histories_query ||= AircraftHistoriesQuery.instance
  end
end
