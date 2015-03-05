class CreateTemplates < ActiveRecord::Migration
  def change
    create_table :templates do |t|
      t.string :display
      t.string :value
      t.string :scenario_title
      t.text :scenario_description
      t.integer :category

      t.timestamps null: false
    end
  end
end
