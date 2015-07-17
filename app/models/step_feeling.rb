class ResultFeeling < ActiveRecord::Base
  enum feeling: [:delighted, :confused]
  belongs_to :scenario_step
  belongs_to :scenario_result

  def self.where_scenario_step_delighted(scenario_step)
    ResultFeeling.where(scenario_step: scenario_step, feeling: feelings[:delighted])
  end

  def self.where_scenario_step_confused(scenario_step)
    ResultFeeling.where(scenario_step: scenario_step, feeling: feelings[:confused])
  end

  def email
    scenario_result.email
  end

end
