class SettingsService
  include Singleton

  def update(survey_settings, survey_params)
    survey_settings.update(
      style_elements: survey_params
    )
  end
end
