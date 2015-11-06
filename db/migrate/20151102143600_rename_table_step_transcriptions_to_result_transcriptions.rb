class RenameTableStepTranscriptionsToResultTranscriptions <ActiveRecord:: Migration
  def change
    rename_table :step_transcriptions, :result_transcriptions
    add_column :result_transcriptions, :scenario_result_id, :integer
    remove_column :result_transcriptions, :result_video_id

    add_column :result_transcriptions, :offset_seconds_backup, :float    
    add_column :result_transcriptions, :step_video_offset_seconds, :float

    # backup result_transcriptions offset_seconds
    execute '
      UPDATE result_transcriptions
      SET offset_seconds_backup = offset_seconds
    '

    # fill in step_videos_offset_seconds
    execute '
      UPDATE result_transcriptions rt
      SET step_video_offset_seconds = sv.offset_seconds
      FROM (
        SELECT offset_seconds, result_step_id
        FROM step_videos
      ) AS sv
      WHERE rt.result_step_id = sv.result_step_id
    '

    # update result_transcriptions offset_seconds
    execute '
      UPDATE result_transcriptions
      SET offset_seconds = offset_seconds + step_video_offset_seconds
    '

    remove_column :result_transcriptions, :step_video_offset_seconds
    rename_column :result_transcriptions, :result_step_id, :result_step_id_backup
  end
end
