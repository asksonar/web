class DashboardPresenter
  def initialize(company_id)
    @company_id = company_id
  end

  def nps_2_weeks_split
    responses_query.nps_by_day(@company_id, from: 2.weeks.ago)
  end

  def nps_2_weeks_total
    responses_query.nps_total(@company_id, from: 2.weeks.ago)
  end

  def latest_comments
    responses_query.comments(@company_id, from: 2.weeks.ago).order(created_at: :desc)
  end

  private

  def responses_query
    @responses_query ||= ResponsesQuery.instance
  end
end
