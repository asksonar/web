class Response < ActiveRecord::Base
  belongs_to :customer

  delegate :region, to: :customer
  delegate :country, to: :customer

  enum status: [:unanswered, :answered, :dismissed]
  enum survey_type: [:inapp, :email]

  after_initialize :default_values, unless: :persisted?

  HASHIDS_SALT = 'Jz$9GFUFqk2z'

  def default_values
    self.status = 'unanswered' if status.nil?
  end
end
