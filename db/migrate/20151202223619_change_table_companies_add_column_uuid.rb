class ChangeTableCompaniesAddColumnUuid < ActiveRecord::Migration
  def change
    add_column :companies, :uuid, :string
  end
end
