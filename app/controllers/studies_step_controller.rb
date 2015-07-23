class StudiesStepController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    scenario_result = ScenarioResult.find_by_hashid(params[:study_id])
    step = JSON.parse(params[:step_json])

    scenario_step = ScenarioStep.find_by_hashid(step['scenarioStepHashId'])
    started_at = Time.at(step['start'] / 1000.0).iso8601(3)
    completed_at = Time.at(step['finish'] / 1000.0).iso8601(3)
    completed_seconds = step['length'] / 1000.0

    result_step = ResultStep.create(
      scenario_result: scenario_result,
      scenario_step: scenario_step,
      started_at: started_at,
      completed_at: completed_at,
      completed_seconds: completed_seconds
    )

    # check for any videos that were inserted previously
    result_step.link_videos

    step['feelings'].each do |feeling|

      feeling_type = feeling['type']
      feeling_at_seconds = feeling['offset'] / 1000.0

      result_feeling = StepFeeling.create(
        result_step: result_step,
        feeling: feeling_type,
        feeling_at_seconds: feeling_at_seconds
      )
    end

    render plain: 'OK'
  end

end
