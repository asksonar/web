class ChangeTableScenarioStepsRemoveUuid < ActiveRecord::Migration
  def change
    remove_column :scenario_steps, :uuid
  end
end
