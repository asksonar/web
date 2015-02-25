class CreateScenarioStepFeelings < ActiveRecord::Migration
  def change
    create_table :scenario_step_feelings do |t|
      t.integer :scenario_id
      t.integer :scenario_step_id
      t.integer :feeling

      t.timestamps null: false
    end
  end
end
