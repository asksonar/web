class ChangeTableSurveySettings <ActiveRecord:: Migration
  def change
    companies = Company.all

    companies.each do |company|
      company.survey_settings = SurveySettings.create
    end
  end
end
