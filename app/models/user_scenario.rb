class UserScenario < ActiveRecord::Base
  belongs_to :scenario
  belongs_to :user

  enum status: %w(pending inprogress completed)

  def self.bulk_create(users, scenario)
    user_scenarios = []
    users.each do |user|
      user_scenarios.push UserScenario
        .create_with(status: :pending)
        .find_or_create_by(user: user,scenario: scenario)
    end
    return user_scenarios
  end
end
