class StepNote < ActiveRecord::Base
  belongs_to :result_step

  HASHIDS_SALT = 'gT#vJBRb*C2h'
end
