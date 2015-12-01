class Response < ActiveRecord::Base
  belongs_to :responder

  HASHIDS_SALT = 'Jz$9GFUFqk2z'
end
