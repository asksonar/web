module Settings
  class SendController < ApplicationController
    before_action :authenticate_user!

    def show
      company = current_user.company
      @survey_settings = company.survey_settings.prezi
    end

    def update
      company = current_user.company
      @survey_settings = company.survey_settings
      service.update(@survey_settings, survey_params)
      flash[:info] = 'Your changes have been updated.'
      redirect_to action: :show
    end

    private

    def service
      @service ||= SendService.instance
    end

    def survey_params
      params.require(:survey_settings).permit(:survey_frequency, :survey_type, :email_followup)
    end
  end
end
