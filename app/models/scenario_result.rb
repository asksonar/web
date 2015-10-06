class ScenarioResult < ActiveRecord::Base
  belongs_to :scenario
  belongs_to :panelist
  has_many :result_steps_pending, -> { pending }, inverse_of: :scenario_step, class_name: 'ResultStep'
  has_many :result_steps, -> { uploaded }, inverse_of: :scenario_step

  enum status: [:pending, :inprogress, :completed, :aborted]

  after_initialize :default_values, unless: :persisted?

  HASHIDS_SALT = 'NCH&Yc!QWk58'

  def default_values
    self.status = self.status || 0
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

  def completed_seconds
    result_steps.sum(:completed_seconds)
  end

  def self.generate_new_sample_result(new_scenario)
    ActiveRecord::Base.transaction do

      sample_scenario_result = ScenarioResult.find(Rails.configuration.properties['sample_scenario_result_id'])

      new_scenario_result = sample_scenario_result.dup
      new_scenario_result.scenario = new_scenario
      new_scenario_result.save

      sample_scenario_steps = sample_scenario_result.scenario.scenario_steps
      new_scenario_steps = new_scenario.scenario_steps

      sample_scenario_steps.zip(new_scenario_steps) do |sample_scenario_step, new_scenario_step|
        if sample_scenario_step.nil? or new_scenario_step.nil?
          break
        end

        result_step = ResultStep.find_by(scenario_step: sample_scenario_step, scenario_result: sample_scenario_result)
        result_step.generate_new_sample_result(new_scenario_step, new_scenario_result)
      end
    end
  end

end
