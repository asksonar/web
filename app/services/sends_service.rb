class SendsService
  include Singleton

  def update(survey_settings, note_params)
    survey_settings.update(note_params)
  end
end
