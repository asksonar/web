class SurveysController < ApplicationController
  before_action :authenticate_researcher!

  def index
    company = current_researcher.company
    @survey_settings = company.survey_settings
  end

  def update
    @survey_settings = SurveySettings.find_by_hashid(params[:id])
    service.update(@survey_settings, survey_params)
    flash[:info] = 'Your changes have been updated.'
    redirect_to root_path
  end

  private

  def service
    @service ||= SurveysService.instance
  end

  def survey_params
    params.require(:survey_settings).permit(:survey_frequency)
  end
end

