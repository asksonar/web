module Settings
  class ViewController < ApplicationController
    before_action :authenticate_user!

    def show
      company = current_user.company
      @survey_settings = company.survey_settings
      style_elements = service.get_style_elements(@survey_settings)

      @company_product_name = style_elements['company_product_name']
      @background_color = style_elements['background_color']
    end

    def update
      company = current_user.company
      @survey_settings = company.survey_settings
      service.update_style_elements(
        @survey_settings,
        filter_empty_params(
          style_params
        )
      )

      flash[:info] = 'Your changes have been updated.'
      redirect_to root_path
    end

    private

    def service
      @service ||= SettingsService.instance
    end

    def style_params
      params.require(:style_elements).permit(:company_product_name, :background_color)
    end

    def filter_empty_params(style_params)
      style_params.delete_if { |_key, value| value.blank? }
    end
  end
end
