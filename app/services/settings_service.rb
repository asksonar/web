class SettingsService
  include Singleton

  def update(survey_settings, survey_params)
    survey_settings.update(survey_params)
  end

  def update_style_elements(survey_settings, style_elements)
    old_style_elements = get_style_elements(survey_settings)
    updated_style_elements = old_style_elements.merge(style_elements)
    survey_settings.update(style_elements: updated_style_elements.to_json)
  end

  def get_style_elements(survey_settings)
    survey_settings.style_elements.nil? ? {} : JSON.parse(survey_settings.style_elements)
  end
end