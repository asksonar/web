class Company < ActiveRecord::Base
  has_many :users, inverse_of: :company
  has_many :customers, inverse_of: :company
  has_one :survey_settings

  after_initialize :default_values, unless: :persisted?
  after_create :create_survey_settings

  HASHIDS_SALT = '&8cCkHr#gHYk'

  def default_values
    self.uuid = SecureRandom.uuid if uuid.nil?
  end

  def create_survey_settings
    self.survey_settings = SurveySettings.create
  end
end
