class DraftsService
  include Singleton

  def create(scenario_params, scenario_steps_params, researcher, publishing)
    # save all the changes
    ActiveRecord::Base.transaction do
      scenario = Scenario.new(scenario_params)
      scenario.created_by = researcher
      scenario.company = researcher.company

      scenario.scenario_steps.build(
        ensure_at_least_one_step(
          filter_trailing_empty_steps(
            scenario_steps_params
          )
        )
      )

      if scenario.valid?
        publish(scenario) if publishing
        scenario.save
        track_study_created(researcher, scenario)
      end

      scenario
    end
  end

  def update(scenario, scenario_params, scenario_steps_params_with_hashid, researcher, publishing)
    ActiveRecord::Base.transaction do
      scenario.assign_attributes(scenario_params)
      update_steps!(
        scenario.scenario_steps,
        ensure_at_least_one_step(
          filter_trailing_empty_steps(
            scenario_steps_params_with_hashid
          )
        )
      )

      if scenario.valid?
        publish(scenario) if publishing
        scenario.save
        track_draft_published(researcher, scenario) if publishing
      end

      scenario
    end
  end

  private

  def analytics
    @analytics ||= Analytics.instance
  end

  def publish(scenario)
    scenario.status = 'live'
    scenario.published_at = Time.new
  end

  def filter_trailing_empty_steps(steps_params)
    steps_params
      .reverse
      .drop_while { |step| step[:description].blank? && step[:url].blank? && step[:hashid].blank? }
      .reverse
  end

  def ensure_at_least_one_step(steps_params)
    steps_params.present? ? steps_params : {}
  end

  def update_steps!(old_steps, new_steps)
    old_steps.each do |old_step|
      new_step_index = new_steps.index { |step| step[:hashid] == old_step.hashid }
      if new_step_index
        new_step = new_steps[new_step_index]
        old_step.description = new_step[:description]
        old_step.url = new_step[:url]
        old_step.step_order = new_step[:step_order]
        new_steps.delete_at(new_step_index)
        # wait for autosave to save it
      else
        old_step.mark_for_destruction
        # wait for autosave to destroy it
      end
    end

    new_steps.select { |step| !step.nil? }.each do |step_params|
      # if it has a hashid, we're trying to restore a deleted connection
      if step_params[:hashid]
        id = ScenarioStep.hashids.decode(step_params[:hashid])[0]
        old_steps.build(step_params.permit(:description, :url, :step_order).merge(id: id))
      else
        old_steps.build(step_params.permit(:description, :url, :step_order))
      end
    end
  end

  def track_study_created(researcher, scenario)
    analytics.study_created(researcher, scenario)
  end

  def track_draft_published(researcher, scenario)
    analytics.draft_published(researcher, scenario)
  end
end
