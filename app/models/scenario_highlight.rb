class ScenarioHighlight < ActiveRecord::Base
  belongs_to :scenario_result

  HASHIDS_SALT = 'd4cBT*YTY@9n'
end
