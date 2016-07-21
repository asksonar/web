class AnalysisPresenter
  def attributes
    [
      :msn, :aircraft_status, :aircraft_manufacturer, :aircraft_model, :aircraft_version,
      :registration, :engine_model, :engine_version, :airline, :owner, :airline_country,
      :build_year, :aircraft_age, :seats, :mtow, :hours_cumulative, :cycles_cumulative
    ]
  end

  def attribute_names
    attributes.map do |attribute|
      if attribute == :msn
        "MSN"
      else
        attribute.to_s.titleize
      end
    end
  end

  def fleets_json
    input = Fleet.pluck(*attributes)
    input.unshift(attribute_names)
  end

  def filters_hash
    filters_hash = {}
    attributes.each do |attribute|
      if attribute == :msn
        filters_hash["MSN"] = fleets_query.filters(attribute)
      else
        filters_hash[attribute.to_s.titleize] = fleets_query.filters(attribute)
      end
    end
    filters_hash
  end

  private

  def fleets_query
    @fleets_query ||= FleetsQuery.instance
  end
end
