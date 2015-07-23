class StudiesVideoController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    scenario_result = ScenarioResult.find_by_hashid(params[:study_id])
    steps = JSON.parse(params[:steps_json])

    uuid = SecureRandom.uuid

    steps.each do |step|
      scenario_step = ScenarioStep.find_by_hashid(step['scenarioStepHashId'])

      offset_seconds = step['offset'] / 1000.0
      length_seconds = step['length'] / 1000.0

      result_video = StepVideo.create(
        scenario_result: scenario_result,
        scenario_step: scenario_step,
        uuid: uuid,
        offset_seconds: offset_seconds,
        length_seconds: length_seconds
      )

      result_step = ResultStep.find_by(scenario_result: scenario_result, scenario_step: scenario_step)
      if !result_step.nil?
        result_video.result_step = result_step
        result_video.save
      end

    end

    render plain: uuid
  end

  def update
    scenario_result = ScenarioResult.find_by_hashid(params[:study_id])
    uuid = params[:id]
    WorkersVideo.process_uploaded_s3_video_async(uuid)
    render plain: 'OK'
  end

end
