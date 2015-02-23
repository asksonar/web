class CreateScenarioSteps < ActiveRecord::Migration
  def change
    create_table :scenario_steps do |t|
      t.integer :test_id
      t.string :description

      t.timestamps null: false
    end
  end
end
