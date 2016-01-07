class SurveySettings < ActiveRecord::Base
  belongs_to :company

  after_initialize :default_values, unless: :persisted?

  enum survey_type: [:inapp, :email]

  HASHIDS_SALT = 'hGd?M>7`ztM.'

  def default_values
    self.survey_frequency = 90 if survey_frequency.nil?
    self.survey_type = 'inapp' if survey_type.nil?
  end
end
