class ResultHighlight < ActiveRecord::Base
  belongs_to :scenario_step
  belongs_to :scenario_result

  def result_step
    ResultStep.find_by(scenario_step: scenario_step, scenario_result: scenario_result)
  end

end
