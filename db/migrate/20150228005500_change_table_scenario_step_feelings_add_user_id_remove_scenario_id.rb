class ChangeTableScenarioStepFeelingsAddUserIdRemoveScenarioId < ActiveRecord::Migration
  def change
    add_column :scenario_step_feelings, :user_id, :integer
    remove_column :scenario_step_feelings, :scenario_id
  end
end
