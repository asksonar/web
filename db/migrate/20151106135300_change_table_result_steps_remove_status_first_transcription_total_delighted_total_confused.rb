class ChangeTableResultStepsRemoveStatusFirstTranscriptionTotalDelightedTotalConfused <ActiveRecord:: Migration
  def change
    rename_column :result_steps, :status, :status_backup
    rename_column :result_steps, :first_transcription, :first_transcription_backup
    rename_column :result_steps, :total_delighted, :total_delighted_backup
    rename_column :result_steps, :total_confused, :total_confused_backup
  end
end
