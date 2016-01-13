class ChangeTableResponsesRenameSurveyType < ActiveRecord::Migration
  def change
    rename_column :responses, :type, :survey_type
  end
end
