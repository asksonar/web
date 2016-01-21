class RenameTableRespondersToCustomers < ActiveRecord::Migration
  def change
    rename_table :responders, :customers
  end
end
