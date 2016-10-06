class ChangeTableAircraftAddColumnEngineName < ActiveRecord::Migration
  def change
    add_column :aircraft, :engine_name, :string
  end
end
