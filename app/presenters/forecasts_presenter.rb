class ForecastsPresenter
  def fleets_query
    @fleets_query ||= FleetsQuery.instance
  end

  def orders_by_operator
    orders_by_operator ||= fleets_query.orders_by_operator
  end
end
