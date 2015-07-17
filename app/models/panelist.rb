class Panelist < ActiveRecord::Base
  has_many :scenario_results

  def is_user?
    true
  end

  def self.bulk_create(emails)
    users = []
    emails.each do |email|
      users.push Panelist.find_or_create_by(email: email)
    end
    return users
  end
end
