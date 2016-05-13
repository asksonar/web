class FleetsPresenter
  attr_reader :display_count

  def initialize(display_count, query_params)
    @display_count = display_count.nil? ? 25 : display_count.to_i
    @query_params = query_params
  end

  def fleets_query
    @fleets_query ||= FleetsQuery.instance
  end

  def fleets
    @fleets ||= fleets_query.fleets(@display_count, filters: @query_params)
  end

  def fleet
    @fleet ||= fleets_query.fleet(@query_params["id"])
  end

  def main_filters
    fleets_query.main_filters
  end

  def sub_filters
    fleets_query.sub_filters(@query_params["main_filter"])
  end
end
