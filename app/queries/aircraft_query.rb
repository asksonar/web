class AircraftQuery
  include Singleton

  def aircraft_fleet(filters: {}, columns:)
    # always add id column to be able to query for hashid
    columns = columns + ["id"]
    data(filters: filters).select(*columns)
  end

  def aircraft_fleet_array(*attributes)
    Aircraft.pluck(*attributes)
  end

  def aircraft(hashid)
    Aircraft.find_by_hashid!(hashid)
  end

  def filters(field)
    Aircraft.distinct(field).where("#{field} IS NOT NULL").order(field).pluck(field)
  end

  private

  def data(filters: {}, options: nil)
    query = Aircraft.where(*where_clause(filters))
    query = query.where(options) if !options.nil?
    query
  end

  def where_clause(filter_hash)
    # {"aircraft_status"=>["Order", "Storage"], {"aircraft_manufacturer"=>["Airbus"]}
    # => ["(aircraft_status = ? OR aircraft_status = ?) AND (aircraft_model = ?)", "In Service", "Order", "A320"]
    where_keys = (filter_hash.map do |key, value|
      or_length = value.nil? ? 1 : [*value].length
      '(' + Array.new(or_length).fill("#{key} = ?").join(' OR ') + ')'
    end).join(' AND ')
    where_values = filter_hash.values
    [where_keys, *where_values.flatten]
  end
end
