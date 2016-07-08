class RenameTableFleetsToFleetsBackup < ActiveRecord::Migration
  def change
    rename_table :fleets, :fleets_backup
  end
end
