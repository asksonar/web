class ChangeTableScenariosAtCompletedAt < ActiveRecord::Migration
  def change
    add_column :scenarios, :completed_at, :datetime
  end
end
