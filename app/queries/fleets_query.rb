class FleetsQuery
  include Singleton

  def fleets(filters: {}, columns:)
    data(filters: filters).select(*columns)
  end

  def fleet(id)
    Fleet.find_by_hashid!(id)
  end

  def filters(field)
    Fleet.distinct(field).order(field).pluck(field)
  end

  def aircraft_by_location(filters: {})
    data(filters: filters)
      .where.not(operator_country: nil)
      .group(:operator_country)
      .pluck(:operator_country, "count(*) as item_count")
  end

  def column_headers(data)
    data.map { |item| item[1] }.uniq.sort
  end

  def group_by_rows(data)
    data.each_with_object({}) do |item, object|
      column_val = item[0]
      row_val = item[1]
      count = item[2]
      object[column_val] = (object[column_val] || {}).merge(row_val => count)
    end
  end

  def fill_empty_fields(data)
    columns = data.values.map(&:keys).flatten.uniq.sort
    data.each_with_object({}) do |(key, value), object|
      columns.each do |column|
        object[key] = value[column].nil? ? (object[key] || {}).merge(column => 0) : (object[key] || {}).merge(value)
      end
    end
  end

  def sort_counts(data)
    data = data.each_with_object({}) do |(key, value), object|
      object[key] = value.sort.to_h.values
    end
  end

  def format_pivot_table(data, columns)
    data = data.map { |key, value| { "header" => key, "data" => value } }
    { "columns" => columns, "rows" => data }
  end

  def orders_by_operator
    current_year = Date.today.year
    data = pivot_by_count(:operator, :build_year, options: "build_year > #{current_year}")
    columns = column_headers(data)
    data = sort_counts(fill_empty_fields(group_by_rows(data)))
    data = format_pivot_table(data, columns)
  end

  def status_by_build_year(filters: {})
    data = pivot_by_count(:build_year, :aircraft_status, filters: filters)
    columns = column_headers(data)
    data = sort_counts(fill_empty_fields(group_by_rows(data)))
    data = format_pivot_table(data, columns)
  end

  def aircraft_age_by_operator(filters: {})
    current_year = Date.today.year

    data = data(filters: filters)
            .group(:operator)
            .group(:age)
            .order(:operator)
            .pluck(
              :operator,
              "(CASE WHEN build_year>#{current_year-3} THEN 0
              WHEN build_year<=#{current_year-3} AND build_year>#{current_year-10} THEN 1
              WHEN build_year<=#{current_year-10} THEN 2
              END) AS age",
              "count(*)")

    columns = column_headers(data)
    data = sort_counts(fill_empty_fields(group_by_rows(data)))
    data = format_pivot_table(data, columns)
  end

  private

  def data(filters: {}, options: nil)
    query = Fleet.where(*where_clause(filters))
    query = query.where(options) if !options.nil?
    query
  end

  def where_clause(filter_hash)
    # {"aircraft_status"=>["Order", "Storage"], {"aircraft_manufacturer"=>["Airbus"]}
    # => ["(aircraft_status = ? OR aircraft_status = ?) AND (aircraft_type = ?)", "In Service", "Order", "A320"]
    where_keys = (filter_hash.map do |key, value|
      or_length = value.nil? ? 1 : [*value].length
      '(' + Array.new(or_length).fill("#{key} = ?").join(' OR ') + ')'
    end).join(' AND ')
    where_values = filter_hash.values
    [where_keys, *where_values.flatten]
  end

  def pivot_by_count(row, column, filters: {}, options: nil)
    data(filters: filters, options: options)
      .group(row)
      .group(column)
      .order(row)
      .pluck("#{row}, #{column}, count(*)")
  end
end
