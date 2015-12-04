class DashboardPresenter
  def initialize(company_id)
    @company_id = company_id
  end

  def nps_2_weeks_split
    responses_query.nps_split_since(@company_id, 2.weeks.ago)
  end

  def nps_2_weeks_total
    responses_query.nps_total_since(@company_id, 2.weeks.ago)
  end

  def latest_comments
    responses_query.comments(@company_id, from: 2.weeks.ago, filter: @filter_hash).order(created_at: :desc)
  end

  private

  def responses_query
    @responses_query ||= ResponsesQuery.instance
  end
end
