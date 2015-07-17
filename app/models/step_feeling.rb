class StepFeeling < ActiveRecord::Base
  enum feeling: [:delighted, :confused]
  belongs_to :result_step

  HASHIDS_SALT = '^Jt^2JQmwe3u'

  def email
    result_step.email
  end

end
