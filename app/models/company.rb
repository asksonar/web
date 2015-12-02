class Company < ActiveRecord::Base
  has_many :researchers, inverse_of: :company
  has_many :responders, inverse_of: :company

  HASHIDS_SALT = '&8cCkHr#gHYk'
end
