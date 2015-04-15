class Scenario < ActiveRecord::Base
	has_many :scenario_steps, -> { order step_order: :asc }, inverse_of: :scenario
  has_many :scenario_results, inverse_of: :scenario
  has_many :result_feelings, through: :scenario_steps
  belongs_to :company
  belongs_to :created_by, class_name: 'Researcher', foreign_key: :created_by
  enum status: [:drafts, :live, :completed]

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
      .order(published_at: :desc)
  end

  def where_feeling_delighted
    result_feelings.where(feeling: ResultFeeling.feelings[:delighted])
  end

  def where_feeling_confused
    result_feelings.where(feeling: ResultFeeling.feelings[:confused])
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
    '/studies/' + hashid
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

  def summary_steps
    scenario_steps.map { |step| SummaryStep.new(step) }
  end

  def highlights
    []
  end

end
