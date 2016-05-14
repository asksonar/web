class FleetsQuery
  include Singleton

  def main_filters
    Fleet.column_names
  end

  def sub_filters(main_filter)
    if !main_filter.nil?
      Fleet
        .select(main_filter)
        .group(main_filter)
        .order(main_filter)
        .pluck(main_filter)
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

  private

  def where_clause(filter_hash)
    # exmaple filter_hash = {"aircraft_status"=>["Order", "Storage"], {"aircraft_manufacturer"=>["Airbus"]}
    where_keys = (filter_hash.map do |key, value|
      or_length = value.nil? ? 1 : [*value].length
      '(' + Array.new(or_length).fill("#{key} = ?").join(' OR ') + ')'
    end).join(' AND ')
    where_values = filter_hash.values
    [where_keys, *where_values.flatten]
  end
end
