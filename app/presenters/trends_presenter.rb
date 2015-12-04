class TrendsPresenter
  def initialize(company_id, date_filter, filter_hash)
    @company_id = company_id
    @date_filter = date_filter
    @filter_hash = filter_hash
  end

  def regions
    responses_query.distinct(@company_id, :region)
  end

  def countries
    responses_query.distinct(@company_id, :country)
  end

  def data_json
    responses_query.responses(@company_id, **date_filter, filter: @filter_hash).to_json
  end

  def nps_by_day_json
    responses_query.nps_by_day(@company_id, **date_filter, filter: @filter_hash).to_json
  end

  def checked(field, value)
    [*(@filter_hash[field])].include?(value)
  end

  private

  def date_filter
    case @date_filter
    when 'past-3-months'
      {from: 3.months.ago}
    when 'past-12-months'
      {from: 12.months.ago}
    else # 'past-1-month'
      {from: 1.month.ago}
    end
  end

  def responses_query
    @responses_query ||= ResponsesQuery.instance
  end
end
