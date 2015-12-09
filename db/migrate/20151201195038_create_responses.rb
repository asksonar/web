class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.integer :responder_id
      t.integer :rating
      t.text :text

      t.timestamps null: false
    end
  end
end
