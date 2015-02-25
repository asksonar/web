class CreateScenarioStepResults < ActiveRecord::Migration
  def change
    create_table :scenario_step_results do |t|
      t.integer :scenario_id
      t.integer :scenario_step_id
      t.datetime :started_at
      t.datetime :completed_at
      t.integer :completed_seconds

      t.timestamps null: false
    end
  end
end
