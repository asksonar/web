class DropTableMetadataTransactionEntries < ActiveRecord::Migration
  def change
    drop_table :metadata_transaction_entries
  end
end
