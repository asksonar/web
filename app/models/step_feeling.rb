class StepFeeling < ActiveRecord::Base
  enum feeling: [:delighted, :confused]
  belongs_to :result_step

  HASHIDS_SALT = '^Jt^2JQmwe3u'

  def generate_new_sample_result(new_result_step)
    new_step_feeling = self.dup
    new_step_feeling.result_step = new_result_step
    new_step_feeling.save
  end
end
