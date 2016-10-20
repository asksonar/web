class DropTableFleetsBackup < ActiveRecord::Migration
  def change
    drop_table :fleets_backup
  end
end
