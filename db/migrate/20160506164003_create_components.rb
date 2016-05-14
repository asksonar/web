class CreateComponents < ActiveRecord::Migration
  def change
    create_table :components do |t|
      t.integer :type
      t.string :serial_number
      t.string :part_number
      t.string :name

      t.timestamps null: false
    end
  end
end
