class ScenarioStepFeeling < ActiveRecord::Base
  enum feeling: [:delighted, :confused]
  belongs_to :scenario
  belongs_to :scenario_step

  def self.where_scenario_step_delighted(scenario_step)
    ScenarioStepFeeling.where(scenario_step: scenario_step, feeling: feelings[:delighted])
  end

  def self.where_scenario_step_confused(scenario_step)
    ScenarioStepFeeling.where(scenario_step: scenario_step, feeling: feelings[:confused])
  end
end
