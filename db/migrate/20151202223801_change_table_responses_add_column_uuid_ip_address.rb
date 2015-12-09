class ChangeTableResponsesAddColumnUuidIpAddress < ActiveRecord::Migration
  def change
    add_column :responses, :uuid, :string
    add_column :responses, :ip_address, :string
  end
end
