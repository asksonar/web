class ScenarioResultsQuery
  include Singleton

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
