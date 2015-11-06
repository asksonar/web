class ResponsesQuery
  include Singleton

  def responses(company:, created_since:nil, limit:20)
    scenarioResult = ScenarioResult
      .joins(:scenario, :result_videos)
      .where(scenarios: {company_id: company})
      .where(scenarios: {status: [Scenario.statuses[:live], Scenario.statuses[:completed]]})
      .where(result_videos: {status: ResultVideo.statuses[:uploaded]})
      .order(created_at: :desc)

    if !created_since.nil?
      scenarioResult = scenarioResult
        .where('result_videos.updated_at >= ?', created_since)
    end

    scenarioResult.first(limit)
  end
end
