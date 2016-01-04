module Settings
  class ViewController < ApplicationController
    before_action :authenticate_user!

    def show
      company = current_user.company
      @survey_settings = company.survey_settings

      if !@survey_settings.style_elements.nil?
        style_elements = JSON.parse(@survey_settings.style_elements)
        @company_product_name = style_elements["company_product_name"]
      else
        @company_product_name = "us"
      end

    end

    def update
      company = current_user.company
      @survey_settings = company.survey_settings
      service.update_style_elements(@survey_settings, style_params)
      flash[:info] = 'Your changes have been updated.'
      redirect_to root_path
    end

    private

    def service
      @service ||= SettingsService.instance
    end

    def style_params
      params.require(:style_elements).permit(:company_product_name)
    end
  end
end
