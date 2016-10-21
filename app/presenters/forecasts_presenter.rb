class ForecastsPresenter
  def orders_by_operator
    orders_by_operator ||= reports_query.orders_by_operator
  end

  private

  def reports_query
    @reports_query ||= ReportsQuery.instance
  end
end
