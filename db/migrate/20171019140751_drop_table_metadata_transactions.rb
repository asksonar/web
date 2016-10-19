class DropTableMetadataTransactions < ActiveRecord::Migration
  def change
    drop_table :metadata_transactions
  end
end
