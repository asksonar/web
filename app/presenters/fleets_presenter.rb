class FleetsPresenter
  attr_reader :display_count

  def initialize(display_count, filter_hash)
    @display_count = display_count.to_i
    @filter_hash = filter_hash
  end

  def fleets_query
    @fleets_query ||= FleetsQuery.instance
  end

  def fleets
    @fleets ||= Fleet.where(aircraft_status: "Order").first(@display_count)
  end

  def main_filters
    fleets_query.main_filters
  end

  def sub_filters
    fleets_query.sub_filters(filters: @filter_hash).to_json
  end
end
