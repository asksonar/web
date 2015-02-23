class ChangeTableScenarioStepsRenameTestIdToScenarioId < ActiveRecord::Migration
  def change
    rename_column :scenario_steps, :test_id, :scenario_id
  end
end
