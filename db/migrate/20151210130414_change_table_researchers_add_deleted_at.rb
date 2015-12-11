class ChangeTableResearchersAddDeletedAt < ActiveRecord::Migration
  def change
    add_column :researchers, :deleted_at, :datetime
  end
end
