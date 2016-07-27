class AnalysisPresenter
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
    input = Aircraft.pluck(*attributes)
    input.unshift(attribute_names)
  end

  def filters_hash
    filters_hash = {}
    attributes.each do |attribute|
      filters_hash[attribute.to_s.titleize] = fleets_query.filters(attribute)
    end
    filters_hash
  end

  private

  def fleets_query
    @fleets_query ||= FleetsQuery.instance
  end
end
