class MetadataTransactionEntry < ActiveRecord::Base
  belongs_to :metadata_transaction
  belongs_to :company

  HASHIDS_SALT = 'QE^3%uXmFD&x'
end
