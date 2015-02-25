class CreateScenarioStepVideos < ActiveRecord::Migration
  def change
    create_table :scenario_step_videos do |t|
      t.integer :scenario_step_id
      t.text :transcription_json

      t.timestamps null: false
    end
  end
end
