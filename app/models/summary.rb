class Summary
  def initialize(scenario, scenario_result)
    @scenario = scenario
    @scenario_result = scenario_result
  end

  def title
    @scenario.title
  end

  def description
    @scenario.description
  end

  def user_count
    @scenario_result.user_count
  end

  def user_completed_count
    @scenario_result.user_completed_count
  end

  def total_delighted
    ScenarioStepFeeling.total_delighted(@scenario)
  end

  def total_confused
    ScenarioStepFeeling.total_confused(@scenario)
  end

  def summary_steps
    @scenario.scenario_step_results
  end

end
