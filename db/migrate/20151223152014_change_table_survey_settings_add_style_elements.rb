class ChangeTableSurveySettingsAddStyleElements < ActiveRecord::Migration
  def change
    add_column :survey_settings, :style_elements, :text
  end
end
