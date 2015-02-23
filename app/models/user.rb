class User < ActiveRecord::Base
  has_many :userScenarios, inverse_of: :scenario, dependent: :destroy

  def isUser?
    true
  end

  def self.bulk_create(emails)
    users = []
    emails.each do |email|
      users.push User.find_or_create_by(email: email)
    end
    return users
  end
end
