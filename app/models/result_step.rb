class ResultStep < ActiveRecord::Base
  belongs_to :scenario_step
  belongs_to :user
  belongs_to :scenario_result
end
