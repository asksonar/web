class ChangeTableSurveySettingsAddSurveyType < ActiveRecord::Migration
  def change
    add_column :survey_settings, :survey_type, :integer
  end
end
