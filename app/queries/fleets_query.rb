class FleetsQuery
  include Singleton

  def main_filters
    Fleet.column_names
  end

  def sub_filters(filters: {})
    if !filters["main_filter"].nil?
      Fleet
        .select(filters["main_filter"])
        .group(filters["main_filter"])
        .order(filters["main_filter"])
        .pluck(filters["main_filter"])
    else
      []
    end
  end

  def fleets(display_count, filters: {})
    if filters.blank?
      Fleet.first(display_count)
    elsif !filters["main_filter"].nil?
      {}
    else
      Fleet
        .where(*where_clause(filters))
        .select(:aircraft_status, :aircraft_type, :serial_number, :build_year, :operator)
        .first(display_count)
    end

  end

  private

  def where_clause(filter_hash)
    # filter_hash = {"aircraft_status"=>["Order", "Storage"], {"aircraft_manufacturer"=>["Airbus"]}
    where_keys = (filter_hash.map do |key, value|
      or_length = value.nil? ? 1 : [*value].length
      '(' + Array.new(or_length).fill("#{key} = ?").join(' OR ') + ')'
    end).join(' AND ')
    where_values = filter_hash.values
    [where_keys, *where_values.flatten]
  end
end
