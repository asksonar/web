class ResultVideosService
  include Singleton

  def link_videos(scenario_result, scenario_step, id)
    ResultVideo.where(
      scenario_result: scenario_result,
      scenario_step: scenario_step
    ).update_all(result_step_id: id)
  end

  def create_from_scenario_result_step_hashid(params, scenario_result_hashid, scenario_step_hashid)
    scenario_result_id = ScenarioResult.hashids.decode(scenario_result_hashid)[0]
    scenario_step_id = ScenarioStep.hashids.decode(scenario_step_hashid)[0]
    create_from_scenario_result_step_id(params, scenario_result_id, scenario_step_id)
  end

  def create_from_scenario_result_step_id(params, scenario_result_id, scenario_step_id)
    result_video = ResultVideo.create(
      params.merge(
        scenario_result_id: scenario_result_id,
        scenario_step_id: scenario_step_id
      )
    )

    result_step = ResultStep.find_by(scenario_result_id: scenario_result_id, scenario_step_id: scenario_step_id)
    if !result_step.nil?
      result_video.result_step = result_step
      result_video.save
    end

    result_video
  end
end
