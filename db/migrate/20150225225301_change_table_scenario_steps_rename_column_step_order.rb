class ChangeTableScenarioStepsRenameColumnStepOrder < ActiveRecord::Migration
  def change
    rename_column :scenario_steps, :order, :step_order
  end
end
