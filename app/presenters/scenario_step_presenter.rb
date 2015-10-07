class ScenarioStepPresenter < SimpleDelegator
  def public_json
    {
      stepDescription: description,
      stepOrder: step_order
    }
  end

  def newest_result_steps
    __getobj__.result_steps.order(created_at: :desc).map(&:prezi)
  end

  def delighted_feelings
    super.map(&:prezi)
  end

  def confused_feelings
    super.map(&:prezi)
  end
end
