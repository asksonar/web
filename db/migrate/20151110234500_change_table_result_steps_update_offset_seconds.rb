class ChangeTableResultStepsUpdateOffsetSeconds <ActiveRecord:: Migration
  def change
    add_column :result_steps, :step_order, :integer

    # update result_step step_order
    execute '
      UPDATE result_steps AS rs
      SET step_order = ss.step_order
      FROM scenario_steps AS ss
      WHERE rs.scenario_step_id = ss.id
    '

    # query for all result_steps with offset_seconds = null
    result_steps = ResultStep
      .where(offset_seconds: nil)
      .order(:scenario_result_id, :step_order)

    # iterate over result_steps
    result_steps.each_with_index do |result_step, index|
      if result_step.step_order == 0
        result_step.offset_seconds = 0
      else
        prev = result_steps[index - 1]
        
        if prev.scenario_step_id != result_step.scenario_step_id && prev.step_order != result_step.step_order - 1
          prev = ResultStep
            .where(scenario_result_id: result_step.scenario_result_id)
            .where(step_order: result_step.step_order - 1)
        end

        result_step.offset_seconds = prev.offset_seconds + prev.completed_seconds
      end
      result_step.save
    end

    remove_column :result_steps, :step_order
  end
end
