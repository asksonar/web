class CreateFleetsV2 < ActiveRecord::Migration
  def change
    create_table :fleets do |t|
      t.string :msn
      t.string :aircraft_status
      t.string :aircraft_manufacturer
      t.string :aircraft_model
      t.string :aircraft_version
      t.string :registration
      t.string :engine_model
      t.string :engine_version
      t.string :airline
      t.string :owner
      t.string :airline_country
      t.integer :build_year
      t.integer :aircraft_age
      t.integer :seat_total
      t.integer :mtow
      t.integer :hours_cumulative
      t.integer :cycles_cumulative
    end
  end
end
