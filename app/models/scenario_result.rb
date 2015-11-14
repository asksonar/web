class ScenarioResult < ActiveRecord::Base
  belongs_to :scenario
  belongs_to :panelist
  belongs_to :created_by, class_name: 'Researcher', foreign_key: :created_by
  has_many :result_steps, inverse_of: :scenario_result
  has_many :result_videos_uploaded, -> { uploaded }, inverse_of: :scenario_result, class_name: 'ResultVideo'
  has_many :result_videos_pending, -> { pending }, inverse_of: :scenario_result, class_name: 'ResultVideo'
  has_many :result_transcriptions, -> { order offset_seconds: :asc }, inverse_of: :scenario_result
  has_many :result_notes, -> { order offset_seconds: :asc }, inverse_of: :scenario_result
  has_many :scenario_highlights, inverse_of: :scenario_result

  enum status: [:pending, :inprogress, :completed, :aborted]

  after_initialize :default_values, unless: :persisted?

  HASHIDS_SALT = 'NCH&Yc!QWk58'

  private

  def default_values
    self.status = status || 0
  end
end
