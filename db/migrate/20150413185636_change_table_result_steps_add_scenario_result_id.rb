class ChangeTableResultStepsAddScenarioResultId < ActiveRecord::Migration
  def change
    add_column :result_steps, :scenario_result_id, :integer
  end
end
