class CreateResponders < ActiveRecord::Migration
  def change
    create_table :responders do |t|
      t.timestamp :first_touch
      t.timestamp :last_touch
      t.string :ip_address
      t.string :region
      t.string :country

      t.timestamps null: false
    end
  end
end
