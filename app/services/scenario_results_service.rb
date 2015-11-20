class ScenarioResultsService
  include Singleton

  def create_result_and_panelist(scenario, email)
    panelist = Panelist.find_by(email: email)
    if panelist.nil?
      panelist = Panelist.create(email: email)
    end

    ScenarioResult.create(scenario: scenario, panelist: panelist)
  end

  def create_result(created_by)
    ScenarioResult.create(created_by: created_by)
  end

  def update(scenario_result, params)
    scenario_result.update(params)
  end

  def generate_new_sample_result(new_scenario)
    ActiveRecord::Base.transaction do
      sample_scenario_result = ScenarioResult.find(Rails.configuration.properties['sample_scenario_result_id'])

      new_scenario_result = sample_scenario_result.dup
      new_scenario_result.scenario = new_scenario
      new_scenario_result.save

      sample_scenario_steps = sample_scenario_result.scenario.scenario_steps
      new_scenario_steps = new_scenario.scenario_steps

      sample_scenario_steps.zip(new_scenario_steps) do |sample_scenario_step, new_scenario_step|
        break if sample_scenario_step.nil? || new_scenario_step.nil?

        result_step = ResultStep.find_by(scenario_step: sample_scenario_step, scenario_result: sample_scenario_result)

        new_result_step = result_step.dup
        new_result_step.scenario_step = new_scenario_step
        new_result_step.scenario_result = new_scenario_result
        new_result_step.save
      end

      sample_scenario_result.result_videos_uploaded.each do |result_video|

        new_result_video = result_video.dup
        new_result_video.scenario_result = new_scenario_result
        new_result_video.save

        s3_utility = S3Utility.new

        s3_utility.list_video(result_video.hashid).each do |object_summary|
          path_ending = object_summary.key.sub(result_video.hashid,'')
          s3_utility.copy_video(object_summary.key, new_result_video.hashid + path_ending)
        end
      end

      sample_scenario_result.result_transcriptions.each do |result_transcription|
        new_step_transcription = result_transcription.dup
        new_step_transcription.scenario_result = new_scenario_result
        new_step_transcription.save
      end
    end
  end
end
