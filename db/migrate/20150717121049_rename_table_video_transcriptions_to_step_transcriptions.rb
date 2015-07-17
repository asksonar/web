class RenameTableVideoTranscriptionsToStepTranscriptions < ActiveRecord::Migration
  def change
    rename_table :video_transcriptions, :step_transcriptions
  end
end
