class CreateMetadataTransactionSets < ActiveRecord::Migration
  def change
    create_table :metadata_transaction_sets do |t|
      t.integer :metadata_transaction_id
      t.integer :company_id
      t.string  :email
      t.hstore  :metadata

      t.timestamps null: false
    end
  end
end
