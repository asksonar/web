class StepHighlight < ActiveRecord::Base
  belongs_to :result_step

  HASHIDS_SALT = '4rzxxh5^qEux'

end
