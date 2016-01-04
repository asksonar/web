class SettingsService
  include Singleton

  def update(survey_settings, survey_params)
    survey_settings.update(survey_params)
  end
end
