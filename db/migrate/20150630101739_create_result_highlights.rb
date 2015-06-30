class CreateResultHighlights < ActiveRecord::Migration
  def change
    create_table :result_highlights do |t|
      t.integer :scenario_step_id
      t.integer :scenario_result_id
      t.float :offset_seconds

      t.timestamps null: false
    end
  end
end
