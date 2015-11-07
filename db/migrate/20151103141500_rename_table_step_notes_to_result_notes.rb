class RenameTableStepNotesToResultNotes <ActiveRecord:: Migration
  def change
    rename_table :step_notes, :result_notes
    add_column :result_notes, :scenario_result_id, :integer
    add_column :result_notes, :offset_seconds_backup, :float    

    # backup result_notes offset_seconds
    execute '
      UPDATE result_notes
      SET offset_seconds_backup = offset_seconds
    '

    # update result_notes offset_seconds
    execute '
      UPDATE result_notes AS rn
      SET offset_seconds = rn.offset_seconds + sv.offset_seconds
      FROM step_videos AS sv
      WHERE rn.result_step_id = sv.result_step_id
    '

    rename_column :result_notes, :result_step_id, :result_step_id_backup
  end
end
