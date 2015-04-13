class ScenarioStep < ActiveRecord::Base
  belongs_to :scenario
  has_many :result_steps, -> { order completed_seconds: :asc }, inverse_of: :scenario_step
  has_many :result_feelings, inverse_of: :scenario_step
  has_many :result_videos, inverse_of: :scenario_step
  #obfuscate_id spin: 10109225

  def where_feeling_delighted
    result_feelings.where(feeling: ResultFeeling.feelings[:delighted])
  end

  def where_feeling_confused
    result_feelings.where(feeling: ResultFeeling.feelings[:confused])
  end
end
