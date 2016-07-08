class RenameFleetsSeatTotal < ActiveRecord::Migration
  def change
    rename_column :fleets, :seat_total, :seats
  end
end
