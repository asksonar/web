class ChangeTableResultHighlightsAddResultStepId < ActiveRecord::Migration
  def change
    add_column :result_highlights, :result_step_id, :integer
    execute '
      UPDATE result_highlights AS rh
      SET result_step_id = rs.id
      FROM result_steps AS rs
      WHERE rh.scenario_step_id = rs.scenario_step_id and rh.scenario_result_id = rs.scenario_result_id
    '
  end
end
