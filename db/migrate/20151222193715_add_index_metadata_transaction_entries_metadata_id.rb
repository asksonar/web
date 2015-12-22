class AddIndexMetadataTransactionEntriesMetadataId < ActiveRecord::Migration
  def change
    add_index :metadata_transaction_entries, :metadata_transaction_id
  end
end
