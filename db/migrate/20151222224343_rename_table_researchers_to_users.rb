class RenameTableResearchersToUsers < ActiveRecord::Migration
  def change
    rename_table :researchers, :users
  end
end
