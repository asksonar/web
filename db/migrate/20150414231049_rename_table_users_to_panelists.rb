class RenameTableUsersToPanelists < ActiveRecord::Migration
  def change
    rename_table :users, :panelists
  end
end
