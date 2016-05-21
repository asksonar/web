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
    Fleet.distinct(main_filter).order(main_filter).pluck(main_filter)
  end

  def orders_by_operator
    current_year = Date.today.year
    source_data = pivot_by_count(:operator, :build_year).where('build_year > ?', current_year)

    g = PivotTable::Grid.new do |g|
      g.source_data  = source_data
      g.column_name  = :build_year
      g.row_name     = :operator
      g.value_name   = :item_count
    end

    g.build
  end

  def status_by_build_year(filters: {})
    source_data = pivot_by_count(:build_year, :aircraft_status)

    g = PivotTable::Grid.new do |g|
      g.source_data  = source_data
      g.column_name  = :aircraft_status
      g.row_name     = :build_year
      g.value_name   = :item_count
    end

    g.build
  end

  def pivot_by_count(row, column, filters: {})
    data(filters)
      .group(row)
      .group(column)
      .select("#{row}, #{column}, count(*) AS item_count")
  end

  def aircraft_by_location(filters: {})
    data(filters)
      .where.not(operator_country: nil)
      .group(:operator_country)
      .pluck(:operator_country, "count(*) as item_count")
  end

  def aircraft_age_by_operator(filters: {})
    current_year = Date.today.year

    source_data =
      data(filters)
        .select(
          :operator,
          "(CASE WHEN build_year>=#{current_year-3} THEN 0
          WHEN build_year<#{current_year-3} AND build_year>=#{current_year-10} THEN 1
          WHEN build_year<#{current_year-10} THEN 2
          END) AS age",
          "count(*) AS item_count"
        )
        .group(:operator)
        .group(:age)
        .order(:operator)

    g = PivotTable::Grid.new do |g|
      g.source_data  = source_data
      g.column_name  = :age
      g.row_name     = :operator
      g.value_name   = :item_count
    end

    g.build
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
