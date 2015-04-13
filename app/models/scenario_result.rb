class ScenarioResult < ActiveRecord::Base
  belongs_to :scenario
  belongs_to :user

  enum status: [:pending, :inprogress, :completed]

  after_initialize :default_values, unless: :persisted?

  def default_values
    self.uuid = SecureRandom.uuid
    self.status = self.status || 0
  end

  def self.bulk_create(users, scenario)
    user_scenarios = []
    users.each do |user|
      user_scenarios.push ScenarioResult
        .create_with(status: :pending)
        .find_or_create_by(user: user, scenario: scenario)
    end
    return user_scenarios
  end

  def email
    return user.email
  end

  def title
    return scenario.title
  end

  def description
    return scenario.description
  end

  def company_name
    return scenario.company.name
  end

end
