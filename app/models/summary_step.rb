class SummaryStep

  def initialize(scenario_step)
    @scenario_step = scenario_step
  end

  def step_order
    @scenario_step.step_order
  end

  def description
    @scenario_step.description
  end

  def average_completed_seconds
    @scenario_step.scenario_step_results.average(:completed_seconds)
  end

  def result_time_hash
    @scenario_step.scenario_step_results.map { |result|
      { id: result.id, time: result.completed_seconds }
    }
  end

  def delighted_feelings
    @scenario_step.where_feeling_delighted || []
  end

  def frustrated_feelings
    @scenario_step.where_feeling_confused || []
  end

end
