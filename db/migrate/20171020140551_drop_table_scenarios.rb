class DropTableScenarios < ActiveRecord::Migration
  def change
    drop_table :scenarios
  end
end
