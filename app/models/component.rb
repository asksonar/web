class Component < ActiveRecord::Base
  belongs_to :aircraft

  validates_presence_of :part_number, :name, :serial_number

  enum type: [:airframe, :engines, :landing_gears, :apu]

  HASHIDS_SALT = 'AGK1vsQcfSqk'
end
