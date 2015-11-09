class ResultStepsService
  include Singleton

  def create(step_params, scenario_result, scenario_step)
    result_step = ResultStep.create(
      step_params.merge(
        scenario_result: scenario_result,
        scenario_step: scenario_step
      )
    )

    result_step
  end
end
