class CreateScenarios < ActiveRecord::Migration
  def change
    create_table :scenarios do |t|
      t.string :title
      t.text :description

      t.timestamps null: false
    end
  end
end
