class SurveySettings < ActiveRecord::Base
  belongs_to :company

  after_initialize :default_values, unless: :persisted?

  validates :survey_frequency, numericality: { greater_than_or_equal_to: 30 }
  validates :email_followup, numericality: { greater_than_or_equal_to: 7, allow_nil: true }

  enum survey_type: [:inapp, :email]

  HASHIDS_SALT = 'hGd?M>7`ztM.'

  def default_values
    self.survey_frequency = 90 if survey_frequency.nil?
    self.survey_type = 'inapp' if survey_type.nil?
  end
end
