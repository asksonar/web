class DropTableScenarioResultsV2 < ActiveRecord::Migration
  def change
    drop_table :scenario_results
  end
end
