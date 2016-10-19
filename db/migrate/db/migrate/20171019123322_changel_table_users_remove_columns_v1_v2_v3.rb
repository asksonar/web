class ChangelTableUsersRemoveColumnsV1V2V3 < ActiveRecord::Migration
  def change
    remove_column :users, :has_v1, :boolean
    remove_column :users, :has_v2, :boolean
    remove_column :users, :has_v3, :boolean
  end
end
