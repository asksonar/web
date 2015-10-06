class StepVideosService
  include Singleton

  def link_videos(scenario_result, scenario_step, id)
    StepVideo.where(
      scenario_result: scenario_result,
      scenario_step: scenario_step
    ).update_all(result_step_id: id)
  end
end
