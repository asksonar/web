class ChangeScenarioHighlightsAddScenarioId < ActiveRecord::Migration
  def change
    add_column :scenario_highlights, :scenario_id, :integer
  end
end
