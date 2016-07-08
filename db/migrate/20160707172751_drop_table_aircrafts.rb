class DropTableAircrafts < ActiveRecord::Migration
  def change
    drop_table :aircrafts
  end
end
