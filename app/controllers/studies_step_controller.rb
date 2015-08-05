class StudiesStepController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    scenario_result = ScenarioResult.find_by_hashid(params[:study_id])
    step = JSON.parse(params[:step_json])
    feelings = step['feelings']
    transcriptions = step['speechRecognition']['results']

    first_transcription = transcriptions.length > 0 ? transcriptions[0]['text'] : ''
    total_delighted = feelings.count { |feeling| feeling['type'] == 'delighted' }
    total_confused = feelings.count { |feeling| feeling['type'] == 'confused' }

    scenario_step = ScenarioStep.find_by_hashid(step['scenarioStepHashId'])
    started_at = Time.at(step['start'] / 1000.0).iso8601(3)
    completed_at = Time.at(step['finish'] / 1000.0).iso8601(3)
    completed_seconds = step['length'] / 1000.0

    result_step = ResultStep.create(
      scenario_result: scenario_result,
      scenario_step: scenario_step,
      started_at: started_at,
      completed_at: completed_at,
      completed_seconds: completed_seconds,
      first_transcription: first_transcription,
      total_delighted: total_delighted,
      total_confused: total_confused,
      status: 'pending'
    )

    # check for any videos that were inserted previously
    result_step.link_videos

    feelings.each do |feeling|

      feeling_type = feeling['type']
      feeling_at_seconds = feeling['offset'] / 1000.0

      step_feeling = StepFeeling.create(
        result_step: result_step,
        feeling: feeling_type,
        feeling_at_seconds: feeling_at_seconds
      )
    end

    transcriptions.each do |transcription|

      transcription_text = transcription['text']
      transcription_at_seconds = transcription['offset'] / 1000.0

      step_transcription = StepTranscription.create(
        result_step: result_step,
        offset_seconds: transcription_at_seconds,
        text: transcription_text
      )
    end

    Resque.enqueue(ProcessTranscriptionWorker, result_step.id)

    render plain: 'OK'
  end

end
