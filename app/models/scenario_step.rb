class ScenarioStep < ActiveRecord::Base
  belongs_to :scenario
  has_many :result_steps_pending, -> { pending }, inverse_of: :scenario_step, class_name: 'ResultStep'
  has_many :result_steps, -> { uploaded }, inverse_of: :scenario_step
  has_many :step_feelings, through: :result_steps
  has_many :step_videos, through: :result_steps

  before_validation :sanitize_description_url

  HASHIDS_SALT = 'c@9F*bVEKWpT'

  def where_feeling_delighted
    step_feelings.delighted
  end

  def where_feeling_confused
    step_feelings.confused
  end

  def completed_users
    result_steps.count
  end

  def total_delighted
    where_feeling_delighted.count
  end

  def total_confused
    where_feeling_confused.count
  end

  private

  def sanitize_description_url
    sanitizer = Rails::Html::FullSanitizer.new
    self.description = sanitizer.sanitize(self.description)
    self.url = sanitizer.sanitize(self.url)
    if self.url.blank?
      self.url = nil
    end
  end
end
