class ChangeTableScenarioStepResultsAddUserIdRemoveScenarioId < ActiveRecord::Migration
  def change
    remove_column :scenario_step_results, :scenario_id
  end
end
