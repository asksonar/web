class ChangeTableResultVideosAddStatus <ActiveRecord:: Migration
  def change
    add_column :result_videos, :status, :integer

    # set status of previous videos to pending
    execute '
      UPDATE result_videos
      SET status = 0
    '

    rename_column :result_videos, :result_step_id, :result_step_id_backup
    rename_column :result_videos, :scenario_step_id, :scenario_step_id_backup
  end
end
