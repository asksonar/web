class ReportsPresenter
  attr_reader :query_params

  def initialize(query_params)
    @query_params = query_params
  end

  def aircraft_type
    fleets_query.sub_filters(:aircraft_type)
  end

  def fleets_query
    @fleets_query ||= FleetsQuery.instance
  end

  def aircraft_age_by_operator
    aircraft_age_by_operator ||= fleets_query.aircraft_age_by_operator(filters: @query_params)

    aircraft_age_by_operator.rows.map.with_index do |row, row_index|
      row.data.map.with_index do |row_data, row_data_index|
        aircraft_age_by_operator.rows[row_index].data[row_data_index] = row_data || {"item_count": 0}
      end
    end

    aircraft_age_by_operator.column_headers.map.with_index do |header, index|
      if header == 0
        aircraft_age_by_operator.column_headers[index] = "Under 3 years"
      elsif header == 1
        aircraft_age_by_operator.column_headers[index] = "3-10 years"
      else
        aircraft_age_by_operator.column_headers[index] = "10 years+"
      end
    end

    aircraft_age_by_operator
  end

  def status_by_build_year
    status_by_build_year ||= fleets_query.status_by_build_year(filters: @query_params)

    status_by_build_year.rows.map.with_index do |row, row_index|
      row.data.map.with_index do |row_data, row_data_index|
        status_by_build_year.rows[row_index].data[row_data_index] = row_data || {"item_count": 0}
      end
    end

    status_by_build_year
  end
end
