class Scenario < ActiveRecord::Base
  belongs_to :company
  belongs_to :created_by, class_name: 'Researcher', foreign_key: :created_by
  has_many :scenario_steps, -> { order step_order: :asc }, inverse_of: :scenario
  has_many :scenario_results, inverse_of: :scenario
  has_many :result_steps, through: :scenario_results
  has_many :step_feelings, through: :result_steps
  has_many :step_highlights, through: :result_steps
  enum status: [:drafts, :live, :completed]

  def can_add_steps?
    self.drafts? or self.user_count.nil? or self.user_count == 0
  end

  def self.create_draft(hash)
    Scenario.create(hash.merge({status: statuses[:drafts]}))
  end

  def self.create_live(hash)
    Scenario.create(hash.merge({
      status: statuses[:live],
      published_at: Time.new
    }))
  end

  def update_draft(hash)
    update(hash.merge({status: Scenario.statuses[:drafts]}))
  end

  def update_live(hash)
    update(hash.merge({
      status: Scenario.statuses[:live],
      published_at: Time.new
    }))
  end

  def set_live()
    self.status = :live
    self.published_at = Time.new
    self.save()
  end

  def set_completed()
    self.status = :completed
    self.completed_at = Time.new
    self.save()
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
      .order(published_at: :desc)
  end

  def step_count
    scenario_steps.count
  end

  def user_count
    scenario_results.count
  end

  def user_completed_count
    scenario_results.where(status: ScenarioResult.statuses[:completed]).count
  end

  def where_feeling_delighted
    step_feelings.where(feeling: StepFeeling.feelings[:delighted])
  end

  def where_feeling_confused
    step_feelings.where(feeling: StepFeeling.feelings[:confused])
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
          hashid: (step.hashid || ''),
          description: (step.description || '').strip,
          url: (step.url || '').strip
        }
      }
    }.to_json
  end

  def share_link
    Rails.configuration.properties['web_base_url'] + '/studies/' + hashid
  end

  def share_link_params_json
    {
      hashid: hashid,
      description: description,
      steps: scenario_steps.map { |step|
        {
          #id: (step.to_param || ''),
          hashid: (step.hashid || ''),
          description: (step.description || '').strip,
          url: (step.url || '').strip
        }
      }
    }.to_json
  end

  def highlights
    step_highlights
  end

end
