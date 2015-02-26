class Scenario < ActiveRecord::Base
	has_many :scenario_steps, -> { order step_order: :asc }, inverse_of: :scenario, dependent: :destroy
  has_many :user_scenarios, inverse_of: :scenario, dependent: :destroy
  has_one :scenario_result
  has_many :scenario_step_results
  belongs_to :company
  belongs_to :created_by, class_name: 'Researcher', foreign_key: :created_by

  def self.create(params, researcher)
    scenario = Scenario.new(params)
    scenario.created_by = researcher
    scenario.company = researcher.company
    scenario.save
    return scenario
  end

  # comment out when we start automatically filling in these denormalized columns
  #def user_count
  #  scenario_result.user_count
    #return user_scenarios.count
  #end

  # comment out when we start automatically filling in these denormalized columns
  #def user_completed_count
  #  scenario_result.user_completed_count
    #return user_scenarios.where(status: UserScenario.statuses[:completed]).count
  #end

end
