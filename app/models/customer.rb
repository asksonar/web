class Customer < ActiveRecord::Base
  belongs_to :company
  has_many :responses, inverse_of: :customer
  has_many :touches, inverse_of: :customer
  store_accessor :metadata

  before_validation :downcase_email

  HASHIDS_SALT = 'd7#7^bMnc^Ue'

  private

  def downcase_email
    email.downcase! if try(:email)
    true
  end
end
