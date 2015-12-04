class TrendsPresenter
  def initialize(company_id, filter_hash)
    @company_id = company_id
    @filter_hash = filter_hash
  end

  def regions
    responses_query.distinct(@company_id, :region)
  end

  def countries
    responses_query.distinct(@company_id, :country)
  end

  def data_json
    responses_query.responses(@company_id, @filter_hash).to_json
  end

  def nps_by_date_json
    responses_query.nps_by_day(@company_id, @filter_hash).to_json
  end

  def checked(field, value)
    [*(@filter_hash[field])].include?(value)
  end

  private

  def responses_query
    @responses_query ||= ResponsesQuery.instance
  end
end
