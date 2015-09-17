class ChangeTableScenariosDefaultStatus < ActiveRecord::Migration
  def change
    change_column :scenarios, :status, :integer, default: 0
  end
end
