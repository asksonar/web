class MetadataTransaction < ActiveRecord::Base
  has_many :metadata_transaction_entries, inverse_of: :metadata_transaction

  HASHIDS_SALT = '4hqp*TKdK&6^'
end
