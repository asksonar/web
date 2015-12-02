class CreateTouches < ActiveRecord::Migration
  def change
    create_table :touches do |t|
      t.integer :responder_id
      t.string :date_yyyymmdd

      t.timestamps null: false
    end
  end
end
