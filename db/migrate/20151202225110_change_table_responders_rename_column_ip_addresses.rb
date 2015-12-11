class ChangeTableRespondersRenameColumnIpAddresses < ActiveRecord::Migration
  def change
    rename_column :responders, :ip_address, :ip_addresses
  end
end
