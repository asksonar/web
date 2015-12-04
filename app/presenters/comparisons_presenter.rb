class ComparisonsPresenter
  def initialize(company_id, category, filter_hash)
    @company_id = company_id
    @category = category
    @filter_hash = filter_hash
  end

  def responses_query
    @responses_query ||= ResponsesQuery.instance
  end

  def regions
    responses_query.distinct(@company_id, :region)
  end

  def countries
    responses_query.distinct(@company_id, :country)
  end

  def data_json
    responses_query.responses(@company_id, filter: @filter_hash).to_json
  end

  def nps_by_category_json
    responses_query.nps_by_category(@company_id, @category, filter: @filter_hash)
      .map { |val| val[@category].nil? ? val.merge(@category => 'UNKNOWN') : val }
      .to_json
  end

  def category
    @category
  end

  def checked(field, value)
    [*(@filter_hash[field])].include?(value)
  end
end
