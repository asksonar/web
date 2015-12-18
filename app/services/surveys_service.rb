class SurveysService
  include Singleton

  def update(survey_settings, note_params)
    survey_settings.update(
      survey_frequency: note_params[:survey_frequency],
    )

    survey_settings
  end

end
