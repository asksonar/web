class ChangeTableResultFeelingAddResultStepId < ActiveRecord::Migration
  def change
    add_column :result_feelings, :result_step_id, :integer
    execute '
      UPDATE result_feelings AS rf
      SET result_step_id = rs.id
      FROM result_steps AS rs
      WHERE rf.scenario_step_id = rs.scenario_step_id and rf.scenario_result_id = rs.scenario_result_id
    '
  end
end
