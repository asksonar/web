class RenameTableUserScenariosToScenarioResults < ActiveRecord::Migration
  def change
    rename_table :user_scenarios, :scenario_results
  end
end
