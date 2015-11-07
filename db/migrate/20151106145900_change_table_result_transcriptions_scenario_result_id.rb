class ChangeTableResultTranscriptionsScenarioResultId <ActiveRecord:: Migration
  def change
    
    execute '
      UPDATE result_transcriptions AS rt
      SET scenario_result_id = rs.scenario_result_id
      FROM result_steps AS rs
      WHERE rt.result_step_id_backup = rs.id
    '

  end
end