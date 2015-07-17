class StepTranscription < ActiveRecord::Base
  belongs_to :result_step

  HASHIDS_SALT = 'AVGutk*f43Sw'

end
