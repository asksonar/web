class ChangeTableAircraftAddColumnEngineManufacturer < ActiveRecord::Migration
  def change
    add_column :aircraft, :engine_manufacturer, :string
  end
end
