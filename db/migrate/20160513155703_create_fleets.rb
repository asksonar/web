class CreateFleets < ActiveRecord::Migration
  def change
    create_table :fleets do |t|
      t.string :aircraft_status
      t.string :aircraft_manufacturer
      t.string :aircraft_type
      t.string :aircraft_series
      t.string :aircraft_variant
      t.string :registration
      t.string :serial_number
      t.string :line_number
      t.integer :build_year
      t.string :operator
      t.string :manager
      t.string :owner
      t.string :owner_type
      t.string :engine_type
      t.string :engine_variant
      t.integer :seat_total
      t.integer :mtow
      t.integer :hours_cumulative
      t.integer :cycles_cumulative
      t.timestamps :effective_date
      t.integer :aircraft_age
      t.string :original_operator
      t.string :operated_for
      t.string :aircraft_usage
      t.string :aircraft_usage2
      t.string :minor_variant
      t.string :operator_area
      t.string :operator_country
      t.string :operator_state
      t.decimal :current_market_value
      t.decimal :current_market_lease_rate
      t.string :financier1
      t.string :noise_category
    end
  end
end
