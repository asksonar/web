class Response < ActiveRecord::Base
  belongs_to :responder

  delegate :region, to: :responder
  delegate :country, to: :responder

  enum status: [:unanswered, :answered, :dismissed]

  after_initialize :default_values, unless: :persisted?

  HASHIDS_SALT = 'Jz$9GFUFqk2z'

  def default_values
    self.status = 'unanswered' if status.nil?
  end
end
