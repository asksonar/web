class ResultStepsService
  include Singleton

  attr_writer :step_videos_service

  def step_videos_service
    @step_videos_service ||= StepVideosService.instance
  end

  def create_with_feelings_transcriptions(step_params, scenario_result, scenario_step)    ActiveRecord::Base.transaction do
      result_step = create(step_params, scenario_result, scenario_step)

      step_videos_service.link_videos(scenario_result, scenario_step, result_step.id)

      result_step
    end
  end

  def create(params, scenario_result, scenario_step)
    ResultStep.create(
      params.merge(
        scenario_result: scenario_result,
        scenario_step: scenario_step,
        status: 'pending'
      )
    )
  end
end
