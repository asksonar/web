class ResultStep < ActiveRecord::Base
  belongs_to :scenario_step
  belongs_to :scenario_result
  has_many :step_feelings, -> { order feeling_at_seconds: :asc }, inverse_of: :result_step
  has_many :step_notes, -> { order offset_seconds: :asc }, inverse_of: :result_step
  has_many :step_videos, -> { order offset_seconds: :asc }, inverse_of: :result_step
  has_many :step_transcriptions, -> { order offset_seconds: :asc }, inverse_of: :result_step
  enum status: [:pending, :uploaded]

  delegate :panelist, to: :scenario_result
  delegate :scenario, to: :scenario_result

  HASHIDS_SALT = '4$g&QNrACfVp'

  def generate_new_sample_result(new_scenario_step, new_scenario_result)
    new_result_step = dup
    new_result_step.scenario_step = new_scenario_step
    new_result_step.scenario_result = new_scenario_result
    new_result_step.save

    step_feelings.each do |step_feeling|
      step_feeling.generate_new_sample_result(new_result_step)
    end
    step_videos.each do |step_video|
      step_video.generate_new_sample_result(new_result_step)
    end
    step_transcriptions.each do |step_transcription|
      step_transcription.generate_new_sample_result(new_result_step)
    end
  end
end
