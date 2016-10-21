class AircraftReportsPresenter
  attr_reader :query_params

  def initialize(query_params)
    @query_params = query_params
  end

  def aircraft_model
    aircraft_query.filters(:aircraft_model)
  end

  def aircraft_age_by_operator
    aircraft_age_by_operator ||= reports_query.aircraft_age_by_operator(filters: @query_params)

    aircraft_age_by_operator["columns"].each_with_index do |header, index|
      if header == 0
        aircraft_age_by_operator["columns"][index] = "Under 3 years"
      elsif header == 1
        aircraft_age_by_operator["columns"][index] = "3-10 years"
      else
        aircraft_age_by_operator["columns"][index] = "10 years+"
      end
    end

    aircraft_age_by_operator
  end

  def status_by_build_year
    status_by_build_year ||= reports_query.status_by_build_year(filters: @query_params)
  end

  def aircraft_by_location_json
    reports_query.aircraft_by_location(filters: @query_params).to_json
  end

  private

  def aircraft_query
    @aircraft_query ||= AircraftQuery.instance
  end

  def reports_query
    @reports_query ||= ReportsQuery.instance
  end
end
