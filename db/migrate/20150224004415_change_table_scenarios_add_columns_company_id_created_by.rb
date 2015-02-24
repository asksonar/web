class ChangeTableScenariosAddColumnsCompanyIdCreatedBy < ActiveRecord::Migration
  def change
    add_column :scenarios, :company_id, :integer
    add_column :scenarios, :created_by, :integer
  end
end
