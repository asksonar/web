class SurveySettings < ActiveRecord::Base
  belongs_to :company

  after_initialize :default_values, unless: :persisted?

  HASHIDS_SALT = 'hGd?M>7`ztM.'

  def default_values
    self.survey_frequency = 30 if survey_frequency.nil?
  end
end
