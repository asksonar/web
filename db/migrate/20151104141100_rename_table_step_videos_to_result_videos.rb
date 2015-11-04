class RenameTableStepVideosToResultVideos <ActiveRecord:: Migration
  def change
    rename_table :step_videos, :result_videos
  end
end
