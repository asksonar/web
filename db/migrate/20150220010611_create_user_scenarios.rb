class CreateUserScenarios < ActiveRecord::Migration
  def change
    create_table :user_scenarios do |t|
      t.integer :user_id
      t.integer :test_id
      t.integer :status

      t.timestamps null: false
    end
  end
end
