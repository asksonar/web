class ChangeTableAircraftsAddColumnsCompanyId < ActiveRecord::Migration
  def change
    add_column :aircrafts, :company_id, :integer
  end
end
