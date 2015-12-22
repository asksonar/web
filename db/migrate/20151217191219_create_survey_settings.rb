class CreateSurveySettings < ActiveRecord::Migration
  def change
    create_table :survey_settings do |t|
      t.integer :survey_frequency
      t.integer :company_id

      t.timestamps null: false
    end
  end
end
