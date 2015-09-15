class ScenarioPresenter < SimpleDelegator
  def public_json
    {
      hashid: hashid,
      description: description,
      steps: scenario_steps_array
    }
  end

  def scenario_steps_array
    scenario_steps.map do |step|
      {
        hashid: step.hashid,
        description: (step.description || '').strip,
        url: (step.url || '').strip
      }
    end
  end

  def share_link
    Rails.configuration.properties['web_base_url'] + '/studies/' + hashid
  end

  def can_add_steps?
    user_count == 0
  end

  def user_completed_count
    completed_ids = scenario_results.completed.select(:id).collect(&:id)
    uploaded_ids = result_steps.select(:scenario_result_id).collect(&:scenario_result_id)

    (completed_ids & uploaded_ids).count
  end

  def user_uploading_count
    completed_ids = scenario_results.completed.select(:id).collect(&:id)
    pending_ids = result_steps_pending.select(:scenario_result_id).collect(&:scenario_result_id)

    (completed_ids & pending_ids).count
  end
end
