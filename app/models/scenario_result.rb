class ScenarioResult < ActiveRecord::Base
  belongs_to :scenario
  belongs_to :panelist
  has_many :result_steps, inverse_of: :scenario_result

  enum status: [:pending, :inprogress, :completed, :aborted]

  after_initialize :default_values, unless: :persisted?

  HASHIDS_SALT = 'NCH&Yc!QWk58'

  def default_values
    self.status = self.status || 0
  end

  def self.bulk_create(users, scenario)
    user_scenarios = []
    users.each do |user|
      user_scenarios.push ScenarioResult
        .create_with(status: :pending)
        .find_or_create_by(panelist: user, scenario: scenario)
    end
    return user_scenarios
  end

  def email
    if panelist.email.empty? then
      'anonymous'
    else
      panelist.email
    end
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
