class ResponsesQuery
  include Singleton

  def responses(company_id:, created_since:nil, limit:20)
    resultStep = ResultStep
      .joins(scenario_step: :scenario)
      .where(scenarios: {company_id: company_id})
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
