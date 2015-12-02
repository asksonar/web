class Response < ActiveRecord::Base
  belongs_to :responder

  delegate :region, to: :responder
  delegate :country, to: :responder

  HASHIDS_SALT = 'Jz$9GFUFqk2z'
end
