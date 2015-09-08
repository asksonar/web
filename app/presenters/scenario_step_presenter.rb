class ScenarioStepPresenter < SimpleDelegator
  def public_json
    {
      stepDescription: description,
      stepOrder: step_order
    }
  end
end
