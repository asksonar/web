class StudiesStepController < ApplicationController
  protect_from_forgery with: :null_session

  attr_writer :result_steps_service
  attr_writer :result_transcriptions_service

  def result_steps_service
    @result_steps_service ||= ResultStepsService.instance
  end

  def result_transcriptions_service
    @result_transcriptions_service ||= ResultTranscriptionsService.instance
  end


  def create
    @scenario_result = ScenarioResult.find_by_hashid!(params_study_hashid)
    @scenario_step = ScenarioStep.find_by_hashid(params_scenario_step_hashid)

    if @scenario_step
      @result_step = result_steps_service.create(
        step_params,
        @scenario_result,
        @scenario_step
      )
      track_respondent_stepped(@scenario_result.scenario)
    end

    result_transcriptions_service.create(transcriptions_params, @scenario_result)

    Resque.enqueue(ProcessTranscriptionWorker, @scenario_result.id)

    render plain: 'OK'
  end

  def track_respondent_stepped(scenario)
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
      completed_seconds: params_step['length'] / 1000.0,
      offset_seconds: params_step['offset'] / 1000.0
    }
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
