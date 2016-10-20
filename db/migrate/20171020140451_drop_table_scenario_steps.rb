class DropTableScenarioSteps < ActiveRecord::Migration
  def change
    drop_table :scenario_steps
  end
end
