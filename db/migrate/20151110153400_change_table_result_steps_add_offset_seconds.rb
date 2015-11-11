class ChangeTableResultStepsAddOffsetSeconds <ActiveRecord:: Migration
  def change
    add_column :result_steps, :offset_seconds, :float

    # set status of previous videos to pending
    execute '
      UPDATE result_steps AS rs
      SET offset_seconds = rv.offset_seconds
      FROM result_videos AS rv
      WHERE rs.id = rv.result_step_id_backup
    '
  end
end
