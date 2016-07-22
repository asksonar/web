class ChangeTableFleets < ActiveRecord::Migration
  def change
    remove_column :fleets, :owner
    remove_column :fleets, :mtow
    remove_column :fleets, :hours_cumulative
    remove_column :fleets, :cycles_cumulative

    add_column :fleets, :line_number, :text
    add_column :fleets, :aircraft_series, :text
    add_column :fleets, :last_delivery_date, :text
    add_column :fleets, :operator_region, :text

    rename_column :fleets, :aircraft_version, :aircraft_type
    rename_column :fleets, :engine_version, :engine_variant
    rename_column :fleets, :airline, :operator
    rename_column :fleets, :airline_country, :operator_country
    rename_column :fleets, :seats, :seats_configuration
  end
end
