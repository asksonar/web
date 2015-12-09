class Touch < ActiveRecord::Base
  belongs_to :responder

  HASHIDS_SALT = '27d&XFsEjc8!'
end
