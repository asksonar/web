class ScenarioStep < ActiveRecord::Base
  belongs_to :scenario
  has_many :result_steps_pending, -> { pending }, inverse_of: :scenario_step, class_name: 'ResultStep'
  has_many :result_steps, -> { uploaded }, inverse_of: :scenario_step
  has_many :step_feelings, through: :result_steps
  has_many :step_videos, through: :result_steps

  before_validation :sanitize_description_url

  validates_presence_of :description

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
    self.description = Sanitize.fragment(description)
    self.url = Sanitize.fragment(url)
    if url.blank?
      self.url = nil
    end
  end
end
