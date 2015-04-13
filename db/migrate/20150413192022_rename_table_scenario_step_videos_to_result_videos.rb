class RenameTableScenarioStepVideosToResultVideos < ActiveRecord::Migration
  def change
    rename_table :scenario_step_videos, :result_videos
    add_column :result_videos, :scenario_result_id, :integer
    remove_column :result_videos, :transcription_json
    remove_column :result_videos, :user_id
  end
end
