class ChangeTableVideoTranscriptionsAddResultStepId < ActiveRecord::Migration
  def change
    add_column :video_transcriptions, :result_step_id, :integer
    execute '
      UPDATE video_transcriptions AS vt
      SET result_step_id = rv.result_step_id
      FROM result_videos AS rv
      WHERE vt.result_video_id = rv.id
    '
  end
end
