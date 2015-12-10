class ChangelTableResearchersAddColumnsV1V2 < ActiveRecord::Migration
  def change
    add_column :researchers, :has_v1, :boolean
    add_column :researchers, :has_v2, :boolean
  end
end
