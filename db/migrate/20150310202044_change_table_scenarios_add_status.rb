class ChangeTableScenariosAddStatus < ActiveRecord::Migration
  def change
    add_column :scenarios, :status, :integer
  end
end
