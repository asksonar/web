class StepFeeling < ActiveRecord::Base
  enum feeling: [:delighted, :confused]
  belongs_to :result_step

  def email
    scenario_result.email
  end

end
