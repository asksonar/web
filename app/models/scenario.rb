class Scenario < ActiveRecord::Base
	has_many :scenario_steps, -> { order step_order: :asc }, inverse_of: :scenario
  has_many :user_scenarios, inverse_of: :scenario
  has_many :scenario_step_feelings, through: :scenario_steps
  belongs_to :company
  belongs_to :created_by, class_name: 'Researcher', foreign_key: :created_by
  enum status: [:drafts, :live, :completed]
  #obfuscate_id spin: 42650656
  after_initialize :default_values, unless: :persisted?

  def default_values
    self.uuid = SecureRandom.uuid
  end

  def self.create_draft(hash)
    Scenario.create(hash.merge({status: statuses[:drafts]}))
  end

  def self.create_live(hash)
    Scenario.create(hash.merge({status: statuses[:live]}))
  end

  def update_draft(hash)
    update(hash.merge({status: Scenario.statuses[:drafts]}))
  end

  def update_live(hash)
    update(hash.merge({status: Scenario.statuses[:live]}))
  end

  def self.drafts(created_by)
    Scenario
      .where(status: statuses[:drafts])
      .where(created_by: created_by)
      .order(updated_at: :desc)
  end

  def self.results(extra_where={})
    Scenario
      .where(status: [statuses[:live], statuses[:completed]])
      .where(extra_where)
  end

  def where_feeling_delighted
    scenario_step_feelings.where(feeling: ScenarioStepFeeling.feelings[:delighted])
  end

  def where_feeling_confused
    scenario_step_feelings.where(feeling: ScenarioStepFeeling.feelings[:confused])
  end

  def total_delighted
    where_feeling_delighted.count
  end

  def total_confused
    where_feeling_confused.count
  end

  def scenario_steps_json
    {
      steps: scenario_steps.map { |step|
        {
          #id: (step.to_param || ''),
          id: (step.id || ''),
          description: (step.description || '').strip,
          url: (step.url || '').strip
        }
      }
    }.to_json
  end

  def share_link
    '/user/scenarios/' + uuid
  end

  def share_link_params_json
    {
      uuid: uuid,
      description: description,
      steps: scenario_steps.map { |step|
        {
          #id: (step.to_param || ''),
          uuid: (step.uuid || ''),
          description: (step.description || '').strip,
          url: (step.url || '').strip
        }
      }
    }.to_json
  end

  def summary_steps
    scenario_steps.map { |step| SummaryStep.new(step) }
  end

end
