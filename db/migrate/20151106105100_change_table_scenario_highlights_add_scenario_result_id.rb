class ChangeTableScenarioHighlightsAddScenarioResultId <ActiveRecord:: Migration
  def change
    add_column :scenario_highlights, :scenario_result_id, :integer
    rename_column :scenario_highlights, :result_step_id, :result_step_id_backup
    rename_column :scenario_highlights, :scenario_id, :scenario_id_backup
  end
end


