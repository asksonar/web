class Scenario < ActiveRecord::Base
  belongs_to :company
  belongs_to :created_by, class_name: 'Researcher', foreign_key: :created_by
  has_many :scenario_steps, -> { order step_order: :asc }, inverse_of: :scenario
  has_many :scenario_results, inverse_of: :scenario
  has_many :result_steps, through: :scenario_results
  has_many :result_steps_pending, through: :scenario_results
  has_many :step_feelings, through: :result_steps
  has_many :scenario_highlights
  has_many :step_notes, through: :result_steps
  enum status: [:drafts, :live, :completed]

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
    scenario_highlights
  end

  private

  def sanitize_and_whitespace_description_title
    self.description = description.gsub(/\r/, '') if description
    sanitizer = Rails::Html::FullSanitizer.new
    self.description = sanitizer.sanitize(description)
    self.title = sanitizer.sanitize(title)
  end
end
