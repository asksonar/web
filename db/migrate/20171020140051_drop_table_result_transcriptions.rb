class DropTableResultTranscriptions < ActiveRecord::Migration
  def change
    drop_table :result_transcriptions
  end
end
