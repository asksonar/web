class Summary
  def initialize(scenario)
    @scenario = scenario
  end

  def title
    @scenario.title
  end

  def description
    @scenario.description
  end

  def user_count
    @scenario.user_count
  end

  def user_completed_count
    @scenario.user_completed_count
  end

  def total_delighted
    @scenario.where_feeling_delighted.count
  end

  def total_confused
    @scenario.where_feeling_confused.count
  end

  def summary_steps
    @scenario.scenario_steps.map { |step| SummaryStep.new(step) }
  end

end
