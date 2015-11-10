class ChangeTableScenarioHighlightsScenarioResultId <ActiveRecord:: Migration
  def change
    
    execute '
      UPDATE scenario_highlights AS sh
      SET scenario_result_id = rs.scenario_result_id
      FROM result_steps AS rs
      WHERE sh.result_step_id_backup = rs.id
    '

  end
end


