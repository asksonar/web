class Scenario < ActiveRecord::Base
	has_many :scenarioSteps, inverse_of: :scenario, dependent: :destroy
  has_many :userScenarios, inverse_of: :scenario, dependent: :destroy
end
