class Touch < ActiveRecord::Base
  belongs_to :customer

  HASHIDS_SALT = '27d&XFsEjc8!'
end
