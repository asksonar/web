class Scenario < ActiveRecord::Base
	has_many :scenarioSteps, inverse_of: :scenario
end
