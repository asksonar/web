class ChangeTableComponentsAddColumnAircraftId < ActiveRecord::Migration
  def change
    add_column :components, :aircraft_id, :integer
  end
end
