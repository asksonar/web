class ChangeTableScenarioStepsAddColumnOrder < ActiveRecord::Migration
  def change
    add_column :scenario_steps, :order, :integer
  end
end
