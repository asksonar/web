class ScenarioStepResult < ActiveRecord::Base
  belongs_to :scenario
  belongs_to :scenario_step
end
