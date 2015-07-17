class ChangeTableResultVideosAddResultStepId < ActiveRecord::Migration
  def change
    add_column :result_videos, :result_step_id, :integer
    execute '
      UPDATE result_videos AS rv
      SET result_step_id = rs.id
      FROM result_steps AS rs
      WHERE rv.scenario_step_id = rs.scenario_step_id and rv.scenario_result_id = rs.scenario_result_id
    '
  end
end
