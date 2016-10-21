class AnalysisPresenter
  def initialize(company)
    @company = company
    @current_view = current_view
    @pivot_params = pivot_params
  end

  def current_view
    @company.analysis_views.where(current_view: true).first()
  end

  def saved_views
    @company.analysis_views.where.not(default_view: true)
  end

  def attributes
    [
      :aircraft_age, :aircraft_manufacturer, :aircraft_model, :aircraft_series,
      :aircraft_status, :aircraft_type, :build_year, :engine_model, :engine_variant,
      :operator, :operator_country, :operator_region, :seats_configuration
    ]
  end

  def attribute_names
    attributes.map do |attribute|
      attribute.to_s.titleize
    end
  end

  def aircraft_fleet_json
    aircraft_fleet = aircraft_query.aircraft_fleet_array(*attributes)
    aircraft_fleet = strip_nil_values(aircraft_fleet)
    aircraft_fleet.unshift(attribute_names)
  end

  def filters_hash
    filters_hash = {}
    attributes.each do |attribute|
      filters_hash[attribute.to_s.titleize] = aircraft_query.filters(attribute)
    end
    filters_hash
  end

  def pivot_params
    JSON.parse(@current_view.pivot_params)
  end

  def checked_filters(field, value)
    @pivot_params["filters"].keys.exclude?(field) || [*(@pivot_params["filters"][field])].exclude?(value)
  end

  def selected(field, subfield, value)
    [*(@pivot_params[field][subfield])].include?(value)
  end

  def filtersArray
    @pivot_params["filtersArray"]
  end

  def rowArray
    @pivot_params["rowArray"]
  end

  def colArray
    @pivot_params["colArray"]
  end

  def attrArray
    @pivot_params["attrArray"]
  end

  private

  def aircraft_query
    @aircraft_query ||= AircraftQuery.instance
  end

  def analysis_views_service
    @analysis_views_service ||= AnalysisViewsService.instance
  end

  def strip_nil_values(nested_array)
    nested_array.map do |array|
      array.map do |value|
        value.nil? ? '' : value
      end
    end
  end
end
