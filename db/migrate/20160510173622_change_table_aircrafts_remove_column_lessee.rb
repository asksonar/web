class ChangeTableAircraftsRemoveColumnLessee < ActiveRecord::Migration
  def change
    remove_column :aircrafts, :lessee, :string
  end
end
