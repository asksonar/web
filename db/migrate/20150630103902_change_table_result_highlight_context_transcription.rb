class ChangeTableResultHighlightContextTranscription < ActiveRecord::Migration
  def change
    add_column :result_highlights, :context_transcription, :text
  end
end
