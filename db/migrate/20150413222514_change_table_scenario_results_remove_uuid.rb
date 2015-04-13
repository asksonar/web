class ChangeTableScenarioResultsRemoveUuid < ActiveRecord::Migration
  def change
    remove_column :scenario_results, :uuid
  end
end
