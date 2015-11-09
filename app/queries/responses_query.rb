class ResponsesQuery
  include Singleton

  def responses(company:, created_since:nil, limit:20)
    resultStep = ResultStep
      .joins(scenario_step: :scenario)
      .where(scenarios: {company_id: company})
      .where(scenarios: {status: [Scenario.statuses[:live], Scenario.statuses[:completed]]})
      .where(scenario_steps: {step_order: 0})

    resultStep = resultStep
      .joins(scenario_result: :result_videos)
      .where(result_videos: {status: ResultVideo.statuses[:uploaded]})
      .uniq
      .order(created_at: :desc)

    if !created_since.nil?
      resultStep = resultStep
        .where('result_steps.updated_at >= ?', created_since)
    end

    resultStep.first(limit)
  end
  # def responses(company:, created_since:nil, limit:20)
  #   scenarioResult = ScenarioResult
  #     .where(scenarios: {company_id: company})
  #     .where(scenarios: {status: [Scenario.statuses[:live], Scenario.statuses[:completed]]})
  #     .where(result_videos: {status: Scenario.statuses[:uploaded]})
  #     .order(created_at: :desc)

  #   if !created_since.nil?
  #     scenarioResult = scenarioResult
  #       .where('scenario_results.updated_at >= ?', created_since)
  #   end

  #   scenarioResult.first(limit)
  # end
end
