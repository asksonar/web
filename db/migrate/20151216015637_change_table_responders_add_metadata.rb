class ChangeTableRespondersAddMetadata < ActiveRecord::Migration
  def change
    enable_extension 'hstore' unless extension_enabled?('hstore')
    add_column :responders, :metadata, :hstore
  end
end
