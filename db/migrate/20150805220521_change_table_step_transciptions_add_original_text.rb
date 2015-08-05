class ChangeTableStepTransciptionsAddOriginalText < ActiveRecord::Migration
  def change
    change_column :step_transcriptions, :text, :text
    add_column :step_transcriptions, :original_text, :text
  end
end
