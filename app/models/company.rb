class Company < ActiveRecord::Base
  has_many :researchers, inverse_of: :company
  has_many :responders, inverse_of: :company

  after_initialize :default_values, unless: :persisted?

  HASHIDS_SALT = '&8cCkHr#gHYk'

  def default_values
    self.uuid = SecureRandom.uuid
  end
end
