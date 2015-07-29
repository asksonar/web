class StepHighlight < ActiveRecord::Base
  belongs_to :result_step

  HASHIDS_SALT = '4rzxxh5^qEux'

  def generate_new_sample_result(new_result_step)
    new_step_highlight = self.dup
    new_step_highlight.result_step = new_result_step
    new_step_highlight.save
  end

end
