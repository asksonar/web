class ScenarioResultsQuery
  include Singleton

  def my_feedback(extra_where = {})
    ScenarioResult
      .joins(:result_videos_uploaded)
      .distinct
      .where(extra_where)
      .order(created_at: :desc)
  end

  def my_feedback_paged(page, page_size, extra_one = false, extra_where = {})
    my_feedback(extra_where)
      .limit(page_size + (extra_one ? 1 : 0))
      .offset(page * page_size)
  end

  def count_newer_than(result, extra_where = {})
    my_feedback(extra_where).where('scenario_results.created_at > ?', result.created_at).count
  end

  def responses(company:, created_since:nil, limit:20)
    query = ScenarioResult
            .joins(:scenario, :result_videos_uploaded)
            .where(scenarios: { company_id: company })
            .where(scenarios: { status: [Scenario.statuses[:live], Scenario.statuses[:completed]] })
            .order(created_at: :desc)

    if !created_since.nil?
      query = query.where('result_videos.updated_at >= ?', created_since)
    end

    query.first(limit)
  end
end
