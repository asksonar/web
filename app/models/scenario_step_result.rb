class ScenarioStepResult < ActiveRecord::Base
  belongs_to :scenario_step
  belongs_to :user
end
