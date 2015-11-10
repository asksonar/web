class ScenarioPresenter < SimpleDelegator
  # needed for bootstrap_form_for
  def self.validators_on(*attributes)
    Scenario.validators_on(*attributes)
  end

  def public_json
    {
      hashid: hashid,
      description: description,
      steps: scenario_steps_array
    }
  end

  def newest_scenario_results
    scenario_results
      .joins(:result_videos_uploaded)
      .order(created_at: :desc).map(&:prezi)
  end

  def step_count
    scenario_steps.count
  end

  def scenario_steps
    super.map(&:prezi)
  end

  def scenario_steps_array
    scenario_steps
      .reject(&:marked_for_destruction?)
      .sort_by(&:step_order)
      .map do |step|
      {
        hashid: step.hashid,
        description: (step.description || '').strip,
        url: (step.url || '').strip,
        errors: step.try(:errors).try(:messages)
      }
    end
  end

  def share_link
    Rails.configuration.properties['web_base_url'] + '/studies/' + hashid
  end

  def can_add_steps?
    scenario_results.count == 0
  end

  def user_completed_count
    completed_ids = scenario_results.completed.select(:id).collect(&:id)
    uploaded_ids = result_videos_uploaded.select(:scenario_result_id).collect(&:scenario_result_id)

    (completed_ids & uploaded_ids).count
  end

  def user_uploading_count
    completed_ids = scenario_results.completed.select(:id).collect(&:id)
    pending_ids = result_videos_pending.select(:scenario_result_id).collect(&:scenario_result_id)

    (completed_ids & pending_ids).count
  end
end
