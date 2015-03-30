class ChangeTableScenariosAddUuid < ActiveRecord::Migration
  def change
    add_column :scenarios, :uuid, :string
    add_column :scenario_steps, :uuid, :string
  end
end
