class ComparisonsPresenter
  def initialize(company_id, comparison_field, filter_hash)
    @company_id = company_id
    @comparison_field = comparison_field
    @filter_hash = filter_hash
  end

  def responses_query
    @responses_query ||= ResponsesQuery.instance
  end

  # def regions
  #   responses_query.distinct(:region)
  # end

  def countries
    responses_query.distinct(@company_id, :country)
  end

  def data_json
    responses_query.responses(@company_id, filter: @filter_hash).to_json
  end

  def nps_by_category_json
    responses_query.nps_by_category(@company_id, @comparison_field, filter: @filter_hash)
      .map { |val| val['region'].nil? ? val.merge(region: 'UNKNOWN') : val }
      .to_json
  end

  def checked(field, value)
    [*(@filter_hash[field])].include?(value)
  end
end
