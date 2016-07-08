class ForecastsPresenter
  def fleets_query
    @fleets_query ||= FleetsQuery.instance
  end

  def orders_by_airline
    orders_by_airline ||= fleets_query.orders_by_airline
  end
end
