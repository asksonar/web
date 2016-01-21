class SurveySettingsPresenter < SimpleDelegator
  # needed for bootstrap_form_for
  def self.validators_on(*attributes)
    SurveySettings.validators_on(*attributes)
  end

  def email_followup_enabled
    !email_followup.nil? && email_followup > 0
  end
end
