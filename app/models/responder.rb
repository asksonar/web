class Responder < ActiveRecord::Base
  belongs_to :company
  has_many :responses, inverse_of: :responder
  has_many :touches, inverse_of: :responder
  store_accessor :metadata

  before_save { email.downcase! if email }

  HASHIDS_SALT = 'd7#7^bMnc^Ue'
end
