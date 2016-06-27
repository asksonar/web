class FleetsPresenter
  attr_reader :display_count

  def initialize(display_count, sort_column, sort_direction, query_params)
    @display_count = display_count
    @sort_column = sort_column
    @sort_direction = sort_direction
    @query_params = query_params
  end

  def fleets_query
    @fleets_query ||= FleetsQuery.instance
  end

  def fleets
    query = fleets_query.fleets(filters: @query_params).order(@sort_column + " " + @sort_direction)
    query = query.first(@display_count) if @display_count != 'All'
    query
  end

  def result_count
    fleets_query.fleets(filters: @query_params).size
  end

  def fleets_json
    query = fleets_query.fleets(filters: @query_params)
    query = query.order(@sort_column + " " + @sort_direction)
    query = query.first(@display_count) if @display_count != 'All'
    query = query.map { |fleet| { "hashid" => fleet.hashid }.merge(fleet.attributes) }
    query
  end

  def fleet
    @fleet ||= fleets_query.fleet(@query_params["id"])
  end

  def filters(field)
    fleets_query.filters(field)
  end
end
