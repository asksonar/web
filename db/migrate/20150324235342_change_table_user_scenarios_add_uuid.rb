class ChangeTableUserScenariosAddUuid < ActiveRecord::Migration
  def change
    add_column :user_scenarios, :uuid, :string
  end
end
