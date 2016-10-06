class ForecastsPresenter
  def aircraft_query
    @aircraft_query ||= AircraftQuery.instance
  end

  def orders_by_operator
    orders_by_operator ||= aircraft_query.orders_by_operator
  end
end
