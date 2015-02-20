class CreateResearchers < ActiveRecord::Migration
  def change
    create_table :researchers do |t|
      t.integer :company_id
      t.string :email

      t.timestamps null: false
    end
  end
end
