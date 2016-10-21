class DropTablePanelists < ActiveRecord::Migration
  def change
    drop_table :panelists
  end
end
