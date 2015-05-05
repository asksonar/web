class ChangeTableScenariosRemoveUuid < ActiveRecord::Migration
  def change
    remove_column :scenarios, :uuid
  end
end
