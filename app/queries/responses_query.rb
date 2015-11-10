class ResponsesQuery
  include Singleton

  def responses(company:, created_since:nil, limit:20)
    scenarioResult = ScenarioResult
      .joins(:scenario, :result_videos_uploaded)
      .where(scenarios: {company_id: company})
      .where(scenarios: {status: [Scenario.statuses[:live], Scenario.statuses[:completed]]})
      .order(created_at: :desc)

    if !created_since.nil?
      scenarioResult = scenarioResult
        .where('result_videos.updated_at >= ?', created_since)
    end

    scenarioResult.first(limit)
  end
end
