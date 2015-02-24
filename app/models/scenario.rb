class Scenario < ActiveRecord::Base
	has_many :scenario_steps, inverse_of: :scenario, dependent: :destroy
  has_many :user_scenarios, inverse_of: :scenario, dependent: :destroy

  def user_count
    return user_scenarios.count
  end

  def user_completed_count
    return user_scenarios.where(status: UserScenario.statuses[:completed]).count
  end

end
