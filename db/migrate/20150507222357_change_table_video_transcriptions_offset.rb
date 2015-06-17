class ChangeTableVideoTranscriptionsOffset < ActiveRecord::Migration
  def change
    change_column :video_transcriptions, :offset, :float
  end
end
