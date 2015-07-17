class StepFeeling < ActiveRecord::Base
  enum feeling: [:delighted, :confused]
  belongs_to :result_step

  def email
    result_step.email
  end

end
