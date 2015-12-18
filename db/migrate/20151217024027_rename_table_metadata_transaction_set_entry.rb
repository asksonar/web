class RenameTableMetadataTransactionSetEntry < ActiveRecord::Migration
  def change
    rename_table :metadata_transaction_sets, :metadata_transaction_entries
  end
end
