class Scenario < ActiveRecord::Base
	has_many :scenarioSteps, inverse_of: :scenario, dependent: :destroy
  has_many :userScenarios, inverse_of: :scenario, dependent: :destroy

  def user_count
    return userScenarios.count
  end

  def user_completed_count
    return userScenarios.where(status: UserScenario.statuses[:completed]).count
  end

end
