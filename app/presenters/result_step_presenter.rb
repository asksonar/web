class ResultStepPresenter < SimpleDelegator
  def scenario_step_order
    scenario_step.step_order
  end

  def scenario_step_description
    scenario_step.description
  end
end
