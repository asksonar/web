class ChangeTableUsersAddColumnsV3 < ActiveRecord::Migration
  def change
    add_column :users, :has_v3, :boolean
  end
end
