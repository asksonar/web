class ChangeTableAircraftsAddColumnsLesseeAssetOwnerAssetManagerRegistrationManufacturerManufactureDateFlightHoursFlightCycles < ActiveRecord::Migration
  def change
    add_column :aircrafts, :lessee, :string
    add_column :aircrafts, :asset_owner, :string
    add_column :aircrafts, :asset_manager, :string
    add_column :aircrafts, :registration, :string
    add_column :aircrafts, :manufacturer, :string
    add_column :aircrafts, :manufacture_date, :datetime
    add_column :aircrafts, :flight_hours, :integer
    add_column :aircrafts, :flight_cycles, :integer
  end
end
