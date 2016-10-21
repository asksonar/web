class DropTableSurveySettings < ActiveRecord::Migration
  def change
    drop_table :survey_settings
  end
end
