class ChangeTableScenariosRemoveColumnsUserCountCompletedCount < ActiveRecord::Migration
  def change
    remove_column :scenarios, :user_count
    remove_column :scenarios, :user_completed_count
  end
end
