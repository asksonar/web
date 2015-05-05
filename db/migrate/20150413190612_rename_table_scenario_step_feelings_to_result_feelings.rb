class RenameTableScenarioStepFeelingsToResultFeelings < ActiveRecord::Migration
  def change
    rename_table :scenario_step_feelings, :result_feelings
    add_column :result_feelings, :scenario_result_id, :integer
    remove_column :result_feelings, :user_id
  end
end
