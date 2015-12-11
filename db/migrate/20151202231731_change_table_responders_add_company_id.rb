class ChangeTableRespondersAddCompanyId < ActiveRecord::Migration
  def change
    add_column :responders, :company_id, :integer
  end
end
