class AddIndexRespondersCompanyIdEmail < ActiveRecord::Migration
  def change
    add_index :responders, [:company_id, :email]
  end
end
