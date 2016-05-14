class CreateAircrafts < ActiveRecord::Migration
  def change
    create_table :aircrafts do |t|
      t.integer :msn
      t.string :aircraft_type
      t.string :aircraft_model

      t.timestamps null: false
    end
  end
end
