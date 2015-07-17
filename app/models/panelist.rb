class Panelist < ActiveRecord::Base
  has_many :scenario_results
  has_many :result_steps, through: :scenario_results
  has_many :step_videos, through: :result_steps
  has_many :result_feelings, through: :scenario_results

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
