class ResultNote < ActiveRecord::Base
  belongs_to :scenario_result

  HASHIDS_SALT = 'gT#vJBRb*C2h'
end
