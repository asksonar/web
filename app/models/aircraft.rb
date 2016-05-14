class Aircraft < ActiveRecord::Base
  belongs_to :company

  has_many :components, inverse_of: :aircraft

  validates_presence_of :msn, :aircraft_type, :aircraft_model

  HASHIDS_SALT = 'Dp0TLkEv8k6e'
end
