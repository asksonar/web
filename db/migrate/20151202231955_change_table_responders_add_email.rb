class ChangeTableRespondersAddEmail < ActiveRecord::Migration
  def change
    add_column :responders, :email, :string
  end
end
