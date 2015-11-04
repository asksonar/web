class ScenarioStep < ActiveRecord::Base
  belongs_to :scenario
  has_many :result_steps_pending, -> { pending }, inverse_of: :scenario_step, class_name: 'ResultStep'
  has_many :result_steps, -> { uploaded }, inverse_of: :scenario_step
  has_many :result_videos, through: :result_steps

  before_validation :trim_description_and_url

  validates_presence_of :description

  HASHIDS_SALT = 'c@9F*bVEKWpT'

  private

  def trim_description_and_url
    self.description = self.description.try(:strip)
    self.description = nil if self.description.blank?
    self.url = self.url.try(:strip)
    self.url = nil if self.url.blank?
  end
end
