class ChangeTableResultStepAddFirstTranscriptionTotalDelightedConfused < ActiveRecord::Migration
  def change
    rename_column :step_transcriptions, :offset, :offset_seconds
    add_column :result_steps, :first_transcription, :text
    execute '
      UPDATE result_steps rs
      SET first_transcription = st.text
      FROM (
        SELECT DISTINCT ON (result_step_id) result_step_id, text, offset_seconds
        FROM step_transcriptions
        ORDER BY result_step_id, offset_seconds ASC
      ) AS st
      WHERE rs.id = st.result_step_id
    '
    add_column :result_steps, :total_delighted, :integer
    execute '
      UPDATE result_steps rs
      SET total_delighted = sf.total_feelings
      FROM (
        SELECT count(1) as total_feelings, result_step_id
        FROM step_feelings
        WHERE feeling = 0
        GROUP BY result_step_id
      ) AS sf
      WHERE rs.id = sf.result_step_id
    '
    add_column :result_steps, :total_confued, :integer
    execute '
      UPDATE result_steps rs
      SET total_delighted = sf.total_feelings
      FROM (
        SELECT count(1) as total_feelings, result_step_id
        FROM step_feelings
        WHERE feeling = 1
        GROUP BY result_step_id
      ) AS sf
      WHERE rs.id = sf.result_step_id
    '
  end
end
