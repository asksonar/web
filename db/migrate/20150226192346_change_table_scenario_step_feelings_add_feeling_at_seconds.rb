class ChangeTableScenarioStepFeelingsAddFeelingAtSeconds < ActiveRecord::Migration
  def change
    add_column :scenario_step_feelings, :feeling_at_seconds, :float
  end
end
