class AircraftHistory < ActiveRecord::Base
  belongs_to :aircraft

  HASHIDS_SALT = 'lALJzPIMHqnD'
end
