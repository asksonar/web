class CreateMetadataTransactions < ActiveRecord::Migration
  def change
    create_table :metadata_transactions do |t|
      # just needed for auto-incremented ids

      t.timestamps null: false
    end
  end
end
