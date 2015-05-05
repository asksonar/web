class CreateVideoTranscriptions < ActiveRecord::Migration
  def change
    create_table :video_transcriptions do |t|
      t.integer :result_video_id
      t.integer :offset
      t.string :text

      t.timestamps null: false
    end
  end
end
