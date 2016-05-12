class FleetsQuery
  include Singleton

  def fleets(display_count, filters: {})
    if filters.blank?
      Fleet.first(display_count)
    elsif !filters["main_filter"].empty? && !filters["sub_filter"].empty?
      Fleet
        .where(filters["main_filter"] => filters["sub_filter"])
        .select(:aircraft_status, :aircraft_type, :serial_number, :build_year, :operator)
        .first(display_count)
    else
      {}
    end
  end

  def main_filters
    Fleet.column_names
  end

  def sub_filters(filters: {})
    Fleet
      .select(filters["main_filter"])
      .group(filters["main_filter"])
      .order(filters["main_filter"])
      .pluck(filters["main_filter"])
  end

end
