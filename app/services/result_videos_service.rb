class ResultVideosService
  include Singleton

  def create_from_scenario_result_hashid(uuid, scenario_result_hashid)
    scenario_result_id = ScenarioResult.hashids.decode(scenario_result_hashid)[0]
    create_from_scenario_result_id(uuid, scenario_result_id)
  end

  def create_from_scenario_result_id(uuid, scenario_result_id)
    result_video = ResultVideo.create(
      uuid: uuid,
      scenario_result_id: scenario_result_id,
      status: 'pending'
    )

    result_video
  end
end
