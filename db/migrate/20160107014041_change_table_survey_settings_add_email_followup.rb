class ChangeTableSurveySettingsAddEmailFollowup < ActiveRecord::Migration
  def change
    add_column :survey_settings, :email_followup, :integer
  end
end
