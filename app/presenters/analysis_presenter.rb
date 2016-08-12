class AnalysisPresenter
  def initialize(company)
    @company = company
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

  def fleets_json
    input = fleets_query.fleets_array(*attributes)
    input.unshift(attribute_names)
  end

  def filters_hash
    filters_hash = {}
    attributes.each do |attribute|
      filters_hash[attribute.to_s.titleize] = fleets_query.filters(attribute)
    end
    filters_hash
  end

  def saved_views
    analysis_views_service.get_saved_views(@company)
  end

  def current_view
    @company.analysis_views.where(current_view: true).first()
  end

  private

  def fleets_query
    @fleets_query ||= FleetsQuery.instance
  end

  def analysis_views_service
    @analysis_views_service ||= AnalysisViewsService.instance
  end
end
