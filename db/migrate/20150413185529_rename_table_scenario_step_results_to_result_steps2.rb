class RenameTableScenarioStepResultsToResultSteps2 < ActiveRecord::Migration
  def change
    rename_table :scenario_step_results, :result_steps
  end
end
