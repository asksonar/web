class ChangeTableScenarioStepResultsAddUserId < ActiveRecord::Migration
  def change
    add_column :scenario_step_results, :user_id, :integer
  end
end
