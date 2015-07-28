class ChangeTableResearchersAddRole < ActiveRecord::Migration
  def change
    add_column :researchers, :role, :integer
  end
end
