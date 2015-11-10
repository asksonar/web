class ResultStep < ActiveRecord::Base
  belongs_to :scenario_step
  belongs_to :scenario_result

  HASHIDS_SALT = '4$g&QNrACfVp'
end
