class Scenario < ActiveRecord::Base
  belongs_to :company
  belongs_to :created_by, class_name: 'User', foreign_key: :created_by
  has_many :scenario_steps, -> { order step_order: :asc }, inverse_of: :scenario, autosave: true
  has_many :scenario_results, inverse_of: :scenario
  has_many :result_steps, through: :scenario_results
  has_many :result_videos_uploaded, through: :scenario_results
  has_many :result_videos_pending, through: :scenario_results
  has_many :scenario_highlights, through: :scenario_results
  has_many :result_notes, through: :scenario_results
  enum status: [:drafts, :live, :completed, :deleted]

  after_initialize :default_values, unless: :persisted?

  validates_presence_of :title, :description

  before_validation :trim_description_and_title

  HASHIDS_SALT = '8UTnU7cJm*bP'

  private

  def default_values
    self.status = 0 if status.nil?
  end

  def trim_description_and_title
    self.description = description.try(:strip)
    self.description = nil if description.blank?
    self.title = title.try(:strip)
    self.title = nil if title.blank?
    true
  end
end
