class ScenarioStepPresenter < SimpleDelegator
  MAX_TIME_BUCKET = 180

  def newest_result_steps
    __getobj__.result_steps.order(created_at: :desc).map(&:prezi)
  end

end
