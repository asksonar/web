class Scenario < ActiveRecord::Base
	has_many :scenario_steps, inverse_of: :scenario, dependent: :destroy
  has_many :user_scenarios, inverse_of: :scenario, dependent: :destroy
  belongs_to :company
  belongs_to :created_by, class_name: 'Researcher', foreign_key: :created_by

  def self.create(params, researcher)
    scenario = Scenario.new(params)
    scenario.created_by = researcher
    scenario.company = researcher.company
    scenario.save
    return scenario
  end

  def user_count
    return user_scenarios.count
  end

  def user_completed_count
    return user_scenarios.where(status: UserScenario.statuses[:completed]).count
  end

end
