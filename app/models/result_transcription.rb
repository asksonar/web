class ResultTranscription < ActiveRecord::Base
  belongs_to :scenario_result

  HASHIDS_SALT = 'AVGutk*f43Sw'

  def generate_new_sample_result(new_result_step)
    new_step_transcription = dup
    new_step_transcription.result_step = new_result_step
    new_step_transcription.save
  end
end
