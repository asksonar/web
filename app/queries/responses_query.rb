class ResponsesQuery
  include Singleton

  def responses(created_by)
    ResultStep
      .joins(scenario_step: :scenario)
      .where(scenarios: {created_by: created_by})
      .where(scenario_steps: {step_order: 0})
      .uploaded
      .order(created_at: :desc)
      .first(20)
      .map(&:prezi)
  end
end
