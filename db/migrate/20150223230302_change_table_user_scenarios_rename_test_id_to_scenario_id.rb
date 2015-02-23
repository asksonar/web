class ChangeTableUserScenariosRenameTestIdToScenarioId < ActiveRecord::Migration
  def change
    rename_column :user_scenarios, :test_id, :scenario_id
  end
end
