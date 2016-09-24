class CreateAircraftHistories < ActiveRecord::Migration
  def change
    create_table :aircraft_histories do |t|
      t.string :aircraft_id
      t.string :aircraft_model
      t.string :aircraft_type
      t.string :registration
      t.datetime :delivery_date
      t.string :operator_name
      t.integer :engine_count
      t.string :engine_manufacturer
      t.string :engine_model
      t.string :engine_variant
      t.string :seats_configuration
      t.string :aircraft_status
      t.text :remarks
    end
  end
end
