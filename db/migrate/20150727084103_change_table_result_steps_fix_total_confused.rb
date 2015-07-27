class ChangeTableResultStepsFixTotalConfused < ActiveRecord::Migration
  def change
    rename_column :result_steps, :total_confued, :total_confused
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
    execute '
      UPDATE result_steps rs
      SET total_confused = sf.total_feelings
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
