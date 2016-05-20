class FleetsPresenter
  attr_reader :display_count

  def initialize(display_count, query_params)
    @display_count = display_count
    @query_params = query_params
  end

  def fleets_query
    @fleets_query ||= FleetsQuery.instance
  end

  def fleets
    fleets_query.fleets(filters: @query_params).first(@display_count)
  end

  def result_count
    fleets_query.fleets(filters: @query_params).size
  end

  def fleets_json
    query = fleets_query.fleets(filters: @query_params)
    query = query.first(@display_count) if @display_count != 'All'
    query = query.map { |fleet| { "hashid" => fleet.hashid }.merge(fleet.attributes) }
    query
  end

  def fleet
    @fleet ||= fleets_query.fleet(@query_params["id"])
  end

  def main_filters
    fleets_query.main_filters
  end

  def sub_filters
    fleets_query.sub_filters(@query_params["main_filter"]).to_json
  end

  def orders_by_operator
    orders_by_operator ||= fleets_query.orders_by_operator

    orders_by_operator.rows.map.with_index do |row, row_index|
      row.data.map.with_index do |row_data, row_data_index|
        orders_by_operator.rows[row_index].data[row_data_index] = row_data || {"item_count": 0}
      end
    end

    orders_by_operator
  end
end
