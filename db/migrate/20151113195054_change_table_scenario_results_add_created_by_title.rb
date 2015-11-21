class ChangeTableScenarioResultsAddCreatedByTitle < ActiveRecord::Migration
  def change
    add_column :scenario_results, :created_by, :integer
    add_column :scenario_results, :title, :string
  end
end
