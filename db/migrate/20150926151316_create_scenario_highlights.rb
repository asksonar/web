class CreateScenarioHighlights < ActiveRecord::Migration
  def change
    create_table :scenario_highlights do |t|
      t.string :title
      t.integer :result_step_id
      t.float :start_seconds
      t.float :end_seconds
      t.text :timeline_elements

      t.timestamps null: false
    end
  end
end
