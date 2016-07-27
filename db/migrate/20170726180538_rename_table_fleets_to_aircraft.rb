class RenameTableFleetsToAircraft < ActiveRecord::Migration
  def change
    rename_table :fleets, :aircraft
  end
end
