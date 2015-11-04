class ResultStep < ActiveRecord::Base
  belongs_to :scenario_step
  belongs_to :scenario_result
  has_many :result_videos, -> { order offset_seconds: :asc }, inverse_of: :result_step
  enum status: [:pending, :uploaded]

  delegate :panelist, to: :scenario_result
  delegate :scenario, to: :scenario_result

  HASHIDS_SALT = '4$g&QNrACfVp'

  def generate_new_sample_result(new_scenario_step, new_scenario_result)
    new_result_step = dup
    new_result_step.scenario_step = new_scenario_step
    new_result_step.scenario_result = new_scenario_result
    new_result_step.save

    result_videos.each do |result_video|
      result_video.generate_new_sample_result(new_result_step)
    end
    result_transcriptions.each do |result_transcription|
      result_transcription.generate_new_sample_result(new_result_step)
    end
  end
end
