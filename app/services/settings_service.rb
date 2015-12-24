class SettingsService
  include Singleton

  def update(survey_settings, survey_params)
    survey_settings.update(
      style_elements: {
        company_product_name: survey_params[:company_product_name]
      }
    )
  end
end
