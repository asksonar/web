class DropTableResultVideos < ActiveRecord::Migration
  def change
    drop_table :result_videos
  end
end
