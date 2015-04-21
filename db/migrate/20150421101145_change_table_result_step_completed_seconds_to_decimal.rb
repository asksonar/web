class ChangeTableResultStepCompletedSecondsToDecimal < ActiveRecord::Migration
  def change
    change_column :result_steps, :completed_seconds, :decimal
    change_column :result_feelings, :feeling_at_seconds, :decimal
  end
end
