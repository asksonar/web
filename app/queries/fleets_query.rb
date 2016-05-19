class FleetsQuery
  include Singleton

  def fleets(filters: {})
    data(filters)
      .select(:id, :aircraft_status, :aircraft_type, :serial_number, :build_year, :operator)
  end

  def fleet(id)
    Fleet.find_by_hashid!(id)
  end

  def main_filters
    Fleet.column_names
  end

  def sub_filters(main_filter)
    Fleet.distinct(main_filter).pluck(main_filter)
  end

  def orders_by_year
    current_year = Date.today.year
    data = pivot_by_count(:operator, :build_year).where('build_year > ?', current_year)

    g = PivotTable::Grid.new do |g|
      g.source_data  = data
      g.column_name  = :build_year
      g.row_name     = :operator
      g.value_name   = :order_count
    end

    g.build
  end

  def pivot_by_count(column, row, filters: {})
    data(filters)
      .group(column)
      .group(row)
      .select("#{column}, #{row}, count(*) AS order_count")
  end

  private

  def data(filters)
    query = Fleet.where(*where_clause(filters))
  end

  def where_clause(filter_hash)
    # filter_hash = {"aircraft_status"=>["Order", "Storage"], {"aircraft_manufacturer"=>["Airbus"]}
    # => ["(aircraft_status = ? OR aircraft_status = ?) AND (aircraft_type = ?)", "In Service", "Order", "A320"]
    where_keys = (filter_hash.map do |key, value|
      or_length = value.nil? ? 1 : [*value].length
      '(' + Array.new(or_length).fill("#{key} = ?").join(' OR ') + ')'
    end).join(' AND ')
    where_values = filter_hash.values
    [where_keys, *where_values.flatten]
  end
end
