class StudiesVideoController < ApplicationController
  protect_from_forgery with: :null_session

  after_action :track_respondent_uploaded, only: :update

  def step_videos_service
    @step_videos_service ||= StepVideosService.instance
  end

  def create
    scenario_result_hashid = params[:study_id]
    uuid = SecureRandom.uuid

    params_step.each do |step|
      step_videos_service.create_from_scenario_result_step_hashid(
        {
          uuid: uuid,
          offset_seconds: step['offset'] / 1000.0,
          length_seconds: step['length'] / 1000.0
        },
        scenario_result_hashid,
        step['scenarioStepHashId']
      )
    end

    render plain: uuid
  end

  def params_step
    JSON.parse(params[:steps_json])
  end

  def update
    @scenario_result = ScenarioResult.find_by_hashid(params[:study_id])
    uuid = params[:id]
    Resque.enqueue(ProcessUploadedS3VideoWorker, uuid)
    render plain: 'OK'
  end

  def track_respondent_uploaded
    scenario = @scenario_result.scenario
    Analytics.instance.respondent_uploaded(request.remote_ip, scenario.created_by, scenario, @scenario_result)
  end

end
