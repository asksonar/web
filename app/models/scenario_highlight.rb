class ScenarioHighlight < ActiveRecord::Base
  belongs_to :scenario
  belongs_to :result_step

  HASHIDS_SALT = 'd4cBT*YTY@9n'
end
