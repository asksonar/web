class ResponsesQuery
  include Singleton

  def responses(created_by:, created_since:nil, limit:20)
    resultStep = ResultStep
      .joins(scenario_step: :scenario)
      .where(scenarios: {created_by: created_by})
      .where(scenario_steps: {step_order: 0})
      .uploaded
      .order(created_at: :desc)

    if !created_since.nil?
      resultStep = resultStep
        .where('result_steps.updated_at >= ?', created_since)
    end

    resultStep.first(limit)
  end
end
