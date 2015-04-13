class ChangeTableResearchersAddColumnFullName < ActiveRecord::Migration
  def change
    add_column :researchers, :full_name, :string
  end
end
