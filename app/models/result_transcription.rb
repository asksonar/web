class ResultTranscription < ActiveRecord::Base
  belongs_to :scenario_result

  HASHIDS_SALT = 'AVGutk*f43Sw'
end
