class StudiesStepController < ApplicationController
  protect_from_forgery with: :null_session

  after_action :track_respondent_stepped, only: :create

  attr_writer :result_steps_service

  def result_steps_service
    @result_steps_service ||= ResultStepsService.instance
  end

  def create
    @scenario_result = ScenarioResult.find_by_hashid(params_study_hashid)
    @scenario_step = ScenarioStep.find_by_hashid(params_scenario_step_hashid)

    @result_step = result_steps_service.create_with_feelings_transcriptions(
      step_params,
      feelings_params,
      transcriptions_params,
      @scenario_result,
      @scenario_step
    )

    Resque.enqueue(ProcessTranscriptionWorker, @result_step.id)

    render plain: 'OK'
  end

  def track_respondent_stepped
    scenario = @scenario_result.scenario
    Analytics.instance.respondent_stepped(request.remote_ip, scenario.created_by, scenario, @scenario_result, @scenario_step, @result_step)
  end

  private

  def params_study_hashid
    params[:study_id]
  end

  def params_step
    @params_step ||= JSON.parse(params[:step_json])
  end

  def params_scenario_step_hashid
    params_step['scenarioStepHashId']
  end

  def step_params
    {
      started_at: Time.at(params_step['start'] / 1000.0).iso8601(3),
      completed_at: Time.at(params_step['finish'] / 1000.0).iso8601(3),
      completed_seconds: params_step['length'] / 1000.0
    }
  end

  def feelings_params
    params_step['feelings'].map do |feeling|
      {
        feeling: feeling['type'],
        feeling_at_seconds: feeling['offset'] / 1000.0
      }
    end
  end

  def transcriptions_params
    params_step['speechRecognition']['results'].map do |transcription|
      {
        offset_seconds: transcription['offset'] / 1000.0,
        text: transcription['text']
      }
    end
  end
end
