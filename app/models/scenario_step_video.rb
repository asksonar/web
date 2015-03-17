class ScenarioStepVideo < ActiveRecord::Base
  belongs_to :user
  belongs_to :scenario_step
end
