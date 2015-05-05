class ChangeTableScenarioResultsRenameUserIdToPanelistId < ActiveRecord::Migration
  def change
    rename_column :scenario_results, :user_id, :panelist_id
  end
end
