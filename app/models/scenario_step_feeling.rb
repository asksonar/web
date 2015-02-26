class ScenarioStepFeeling < ActiveRecord::Base
  enum feeling: [:delighted, :confused]
  belongs_to :scenario
  belongs_to :scenario_step

  def self.total_delighted(scenario)
    ScenarioStepFeeling.where(scenario: scenario, feeling: :delighted).count
  end

  def self.total_confused(scenario)
    ScenarioStepFeeling.where(scenario: scenario, feeling: :confused).count
  end
end
