class ChangeTableAircraftChangeColumnTypes < ActiveRecord::Migration
  def change
    change_column :aircraft, "build_year", :string
    change_column :aircraft, "aircraft_age", :string
    change_column :aircraft, "seats_configuration", :string
    change_column :aircraft, "line_number", :string
    change_column :aircraft, "aircraft_series", :string
    change_column :aircraft, "last_delivery_date", :string
    change_column :aircraft, "operator_region", :string
  end
end
