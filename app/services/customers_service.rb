require 'csv'

class RespondersService
  include Singleton

  def batch_update_metadata(company, metadatas)
    transaction = create_metadata_transaction
    columns, values = build_metadata_transaction_entries(transaction, company, metadatas)
    insert_metadata_transaction_entries(columns, values)
    insert_responders(transaction)
    update_responder_metadata(transaction)
  end

  private

  def create_metadata_transaction
    MetadataTransaction.create
  end

  def build_metadata_transaction_entries(transaction, company, metadatas)
    metadata_transaction_id = transaction.id
    company_id = company.id

    columns = [:metadata_transaction_id, :company_id, :email, :metadata]
    values = metadatas.map do |metadata|
      [
        metadata_transaction_id,
        company_id,
        metadata.delete('email'),
        metadata
      ]
    end
    [columns, values]
  end

  def insert_metadata_transaction_entries(columns, values)
    # TODO: this is too slow, even though the insert is very fast when executed directly
    MetadataTransactionEntry.import(columns, values, validate: false)
  end

  def insert_responders(transaction)
    # insert responders that don't exist
    ActiveRecord::Base.connection_pool.with_connection do |connection|
      connection.execute "
        INSERT into responders(email, company_id, metadata, created_at, updated_at)
        SELECT m.email, m.company_id, m.metadata, now(), now()
        FROM metadata_transaction_entries m
        LEFT OUTER JOIN responders r
        ON m.email = r.email AND m.company_id = r.company_id
        WHERE r.email IS NULL AND m.metadata_transaction_id = #{transaction.id}
      "
    end
  end

  def update_responder_metadata(transaction)
    # update responders' metadata
    metadata_diffs = Responder.find_by_sql "
      SELECT r.metadata old_metadata, m.metadata new_metadata, r.id
      FROM responders r, metadata_transaction_entries m
      WHERE r.company_id = m.company_id
        AND r.email = m.email
        AND ((r.metadata <> m.metadata)
          OR (r.metadata IS NULL AND m.metadata IS NOT NULL)
        )
        AND m.metadata_transaction_id = #{transaction.id}
    "

    ActiveRecord::Base.transaction do
      metadata_diffs.each do |diff|
        merged_data = (diff['old_metadata'] || {}).merge(diff['new_metadata'])
        diff.update_attribute(:metadata, merged_data)
      end
    end
  end
end
