class FleetsQuery
  include Singleton

  def main_filters
    Fleet.column_names
  end

  def sub_filters(filters: {})
    Fleet
      .select(filters["main_filter"])
      .group(filters["main_filter"])
      .pluck(filters["main_filter"])
  end

end
