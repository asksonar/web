class ResultStepsService
  include Singleton

  attr_writer :step_feelings_service
  attr_writer :step_transcriptions_service
  attr_writer :step_videos_service

  def step_feelings_service
    @step_feelings_service ||= StepFeelingsService.instance
  end

  def step_transcriptions_service
    @step_transcriptions_service ||= StepTranscriptionsService.instance
  end

  def step_videos_service
    @step_videos_service ||= StepVideosService.instance
  end

  def create_with_feelings_transcriptions(step_params, feelings_params, transcriptions_params, scenario_result, scenario_step)
    ActiveRecord::Base.transaction do
      result_step = create(step_params, scenario_result, scenario_step)

      step_feelings_service.create(feelings_params, result_step)
      step_transcriptions_service.create(transcriptions_params, result_step)

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

  def update_feeling_count(result_step)
    result_step.total_delighted = result_step.feelings_delighted.count
    result_step.total_confused = result_step.feelings_confused.count
    result_step.save
  end

end