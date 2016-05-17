class FleetsQuery
  include Singleton

  def main_filters
    Fleet.column_names
  end

  def sub_filters(main_filter)
    if !main_filter.nil? # on selecting main_filter
      Fleet
        .select(main_filter)
        .group(main_filter)
        .order(main_filter)
        .pluck(main_filter)
    else # when querying for filtered fleets
      []
    end
  end

  def fleets(display_count, filters: {})
    if filters.blank? # initial load
      Fleet.first(display_count)
    elsif !filters["main_filter"].nil? # when querying for sub_filters
      {}
    else # on adding filters
      fleets = Fleet
                .where(*where_clause(filters))
                .select(:id, :aircraft_status, :aircraft_type, :serial_number, :build_year, :operator)
                .first(display_count)

      # hashid needed by handlebar to generate the correct fleet page href
      fleets = fleets.map do |fleet|
        { hashid: fleet.hashid }.merge(fleet.attributes)
      end
    end
  end

  def fleet(id)
    Fleet.find_by_hashid!(id)
  end

  def orders_by_year
    # build_years = column_list(:build_year, "build_year > ?", 2016)

    data = Fleet
      .select(:operator, :build_year, 'COUNT(*) AS order_count')
      .where('build_year > ?', 2016)
      .where('build_year < ?', 2030)
      .group(:operator, :build_year)

    g = PivotTable::Grid.new do |g|
      g.source_data  = data
      g.column_name  = :build_year
      g.row_name     = :operator
      g.value_name   = :order_count
    end

    g.build
  end

  private

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

  def column_list(column, filter_key, filter_value)
    Fleet.distinct(column).where(filter_key, filter_value).pluck(column)
  end
end
