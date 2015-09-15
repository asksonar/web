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

  after_initialize :default_values, unless: :persisted?
  after_create :track_study_created
  before_validation :sanitize_and_whitespace_description_title

  HASHIDS_SALT = '8UTnU7cJm*bP'

  def step_count
    scenario_steps.count
  end

  def user_count
    scenario_results.count
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
    def default_values
      self.status = 'drafts'
    end

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
