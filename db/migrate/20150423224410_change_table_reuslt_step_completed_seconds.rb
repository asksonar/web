class ChangeTableReusltStepCompletedSeconds < ActiveRecord::Migration
  def change
    change_column :result_steps, :completed_seconds, :float
    change_column :result_feelings, :feeling_at_seconds, :float
  end
end
