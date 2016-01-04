module Settings
  class ViewController < ApplicationController
    before_action :authenticate_user!

    def show
      company = current_user.company
      @survey_settings = company.survey_settings

      if !@survey_settings.style_elements.nil?
        style_elements_string = @survey_settings.style_elements
        style_elements_hash = JSON.parse style_elements_string.gsub('=>', ':')
        @company_product_name = style_elements_hash["company_product_name"]
      else
        @company_product_name = "us"
      end

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
      {
        style_elements: params.require(:style_elements).permit(:company_product_name)
      }
    end
  end
end
