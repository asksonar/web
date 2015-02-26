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

  def completed_time_and_video_json
    @scenario_step.scenario_step_results.map { |step| step.completed_seconds }.to_json
  end

  def delighted_feelings
    @scenario_step.where_feeling_delighted || []
  end

  def frustrated_feelings
    @scenario_step.where_feeling_confused || []
  end

end
