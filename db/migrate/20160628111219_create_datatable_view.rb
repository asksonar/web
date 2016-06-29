class CreateDatatableView < ActiveRecord::Migration
  def change
    create_table :datatable_view do |t|
      t.text :datatable_columns
      t.integer :company_id
      t.string :name
      t.boolean :default_view

      t.timestamps null: false
    end
  end
end
