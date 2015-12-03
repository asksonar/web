class TrendsPresenter
  def initialize(filter_hash)
    @filter_hash = filter_hash
  end

  def responses_query
    @responses_query ||= ResponsesQuery.instance
  end

  def regions
    responses_query.distinct(:region)
  end

  def countries
    responses_query.distinct(:country)
  end

  def data_json
    responses_query.responses(@filter_hash).to_json
  end

  def nps_by_date_json
    responses_query.nps_by_day(@filter_hash).to_json
  end

  def checked(field, value)
    [*(@filter_hash[field])].include?(value)
  end
end
