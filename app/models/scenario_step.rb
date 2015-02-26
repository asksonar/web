class ScenarioStep < ActiveRecord::Base
  belongs_to :scenario
  has_many :scenario_step_results, -> { order completed_seconds: :asc }, inverse_of: :scenario_step
  has_many :scenario_step_feelings, inverse_of: :scenario_step

  def where_feeling_delighted
    scenario_step_feelings.where(feeling: ScenarioStepFeeling.feelings[:delighted])
  end

  def where_feeling_confused
    scenario_step_feelings.where(feeling: ScenarioStepFeeling.feelings[:confused])
  end
end
