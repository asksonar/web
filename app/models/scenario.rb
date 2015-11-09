class Scenario < ActiveRecord::Base
  belongs_to :company
  belongs_to :created_by, class_name: 'Researcher', foreign_key: :created_by
  has_many :scenario_steps, -> { order step_order: :asc }, inverse_of: :scenario, autosave: true
  has_many :scenario_results, inverse_of: :scenario
  has_many :result_steps, through: :scenario_results
  has_many :result_videos_uploaded, through: :scenario_results
  has_many :result_videos_pending, through: :scenario_results
  has_many :scenario_highlights
  has_many :result_notes, through: :scenario_results
  enum status: [:drafts, :live, :completed, :deleted]

  after_initialize :default_values, unless: :persisted?

  validates_presence_of :title, :description

  before_validation :trim_description_and_title

  HASHIDS_SALT = '8UTnU7cJm*bP'

  private
  
  def default_values
    self.status = status || 0
  end

  def trim_description_and_title
    self.description = self.description.try(:strip)
    self.description = nil if self.description.blank?
    self.title = self.title.try(:strip)
    self.title = nil if self.title.blank?
  end
end
