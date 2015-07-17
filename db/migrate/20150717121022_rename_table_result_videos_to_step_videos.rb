class RenameTableResultVideosToStepVideos < ActiveRecord::Migration
  def change
    rename_table :result_videos, :step_videos
  end
end
