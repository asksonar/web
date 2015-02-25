class ChangeTableScenariosAddColumnsUserCountCompletedCount < ActiveRecord::Migration
  def change
    add_column :scenarios, :user_count, :integer
    add_column :scenarios, :user_completed_count, :integer
  end
end
