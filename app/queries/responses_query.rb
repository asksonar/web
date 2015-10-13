class ResponsesQuery
  include Singleton

  def responses(responseParams = {})
    resultStep = ResultStep
      .joins(scenario_step: :scenario)
      .where(scenarios: {created_by: responseParams[:created_by]})
      .where(scenario_steps: {step_order: 0})
      .uploaded
      .order(created_at: :desc)

    if responseParams[:created_since].present?
      resultStep = resultStep
        .where('result_steps.created_at >= ?', responseParams[:created_since])
    end

    resultStep = resultStep
      .first(20)
      .map(&:prezi)
  end
end
