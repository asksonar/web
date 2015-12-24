module Settings
  class ViewController < ApplicationController
    before_action :authenticate_user!

    def show
      company = current_user.company
      @survey_settings = company.survey_settings
    end

    def update
      company = current_user.company
      @survey_settings = company.survey_settings
      service.update(@survey_settings, survey_params)
      flash[:info] = 'Your changes have been updated.'
      redirect_to root_path
    end

    private

    def service
      @service ||= SettingsService.instance
    end

    def survey_params
      params.require(:style_elements).permit(:company_product_name)
    end
  end
end
