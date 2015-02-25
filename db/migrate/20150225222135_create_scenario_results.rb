class CreateScenarioResults < ActiveRecord::Migration
  def change
    create_table :scenario_results do |t|
      t.integer :scenario_id
      t.integer :user_count
      t.integer :user_completed_count

      t.timestamps null: false
    end
  end
end
