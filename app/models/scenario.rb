class Scenario < ActiveRecord::Base
  belongs_to :company
  belongs_to :created_by, class_name: 'Researcher', foreign_key: :created_by
  has_many :scenario_steps, -> { order step_order: :asc }, inverse_of: :scenario
  has_many :scenario_results, inverse_of: :scenario
  has_many :result_steps, through: :scenario_results
  has_many :result_steps_pending, through: :scenario_results
  has_many :step_feelings, through: :result_steps
  has_many :step_highlights, through: :result_steps
  has_many :step_notes, through: :result_steps
  enum status: [:drafts, :live, :completed]

  after_create :track_study_created
  before_validation :sanitize_and_whitespace_description_title

  HASHIDS_SALT = '8UTnU7cJm*bP'

  def can_add_steps?
    user_count == 0
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
    track_draft_published()
  end

  def set_live()
    self.status = :live
    self.published_at = Time.new
    save
  end

  def set_completed()
    self.status = :completed
    self.completed_at = Time.new
    save
  end

  def self.drafts(created_by)
    Scenario
      .where(status: statuses[:drafts])
      .where(created_by: created_by)
      .order(updated_at: :desc)
  end

  def self.results(extra_where = {})
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
    completed_ids = scenario_results.completed.select(:id).collect(&:id)
    uploaded_ids = result_steps.select(:scenario_result_id).collect(&:scenario_result_id)

    (completed_ids & uploaded_ids).count
  end

  def user_uploading_count
    completed_ids = scenario_results.completed.select(:id).collect(&:id)
    pending_ids = result_steps_pending.select(:scenario_result_id).collect(&:scenario_result_id)

    (completed_ids & pending_ids).count
  end

  def where_feeling_delighted
    step_feelings.delighted
  end

  def where_feeling_confused
    step_feelings.confused
  end

  def total_delighted
    where_feeling_delighted.count
  end

  def total_confused
    where_feeling_confused.count
  end

  def highlights
    step_highlights
  end

  protected
    def sanitize_and_whitespace_description_title
      self.description = self.description.gsub(/\r/, '') if self.description;
      sanitizer = Rails::Html::FullSanitizer.new
      self.description = sanitizer.sanitize(self.description)
      self.title = sanitizer.sanitize(self.title)
    end

    def track_study_created
      Analytics.instance.study_created(self.created_by, self)
    end

    def track_draft_published
      Analytics.instance.draft_published(self.created_by, self)
    end

end
