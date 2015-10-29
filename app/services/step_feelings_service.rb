class StepFeelingsService
  include Singleton

  def result_steps_service
    @result_steps_service ||= ResultStepsService.instance
  end

  def create(params, result_step)
    params.each do |feeling|
      result_step.step_feelings.create(feeling)
    end

    result_step.step_feelings
  end
end
