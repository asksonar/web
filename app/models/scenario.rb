class Scenario < ActiveRecord::Base
	has_many :scenario_steps, -> { order step_order: :asc }, inverse_of: :scenario
  has_many :user_scenarios, inverse_of: :scenario
  has_many :scenario_step_feelings, through: :scenario_steps
  belongs_to :company
  belongs_to :created_by, class_name: 'Researcher', foreign_key: :created_by

  def self.create(params, researcher)
    scenario = Scenario.new(params)
    scenario.created_by = researcher
    scenario.company = researcher.company
    scenario.save
    return scenario
  end

  def where_feeling_delighted
    scenario_step_feelings.where(feeling: ScenarioStepFeeling.feelings[:delighted])
  end

  def where_feeling_confused
    scenario_step_feelings.where(feeling: ScenarioStepFeeling.feelings[:confused])
  end

end
