class ChangeTableResultNotesScenarioResultId <ActiveRecord:: Migration
  def change
    
    execute '
      UPDATE result_notes AS rn
      SET scenario_result_id = rs.scenario_result_id
      FROM result_steps AS rs
      WHERE rn.result_step_id_backup = rs.id
    '

  end
end