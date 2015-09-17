class DraftsService
  include Singleton

  def create(scenario_params, scenario_steps_params, researcher, publishing)
    # save all the changes
    ActiveRecord::Base.transaction do
      scenario = Scenario.new(scenario_params)
      scenario.status = 'drafts'
      publish!(scenario) if publishing
      scenario.created_by = researcher
      scenario.company = researcher.company
      scenario.save

      scenario.scenario_steps.create(scenario_steps_params.map { |params| params.permit(:description, :url, :step_order) })

      track_study_created(researcher, scenario)

      scenario
    end
  end

  def update(scenario, scenario_params, scenario_steps_params, researcher, publishing)
    ActiveRecord::Base.transaction do
      scenario.update(scenario_params)
      publish!(scenario) if publishing

      update_steps!(scenario.scenario_steps, scenario_steps_params)

      track_draft_published(researcher, scenario) if publishing

      scenario
    end
  end

  def publish!(scenario)
    scenario.status = 'live'
    scenario.published_at = Time.new
  end

  def update_steps!(old_steps, new_steps)
    old_steps.each do |old_step|
      new_step_index = new_steps.index { |step| step[:hashid] == old_step.hashid }
      if new_step_index
        new_step = new_steps[new_step_index]
        old_step.description = new_step[:description]
        old_step.url = new_step[:url]
        old_step.step_order = new_step[:step_order]
        old_step.save
        new_steps.delete_at(new_step_index)
      else
        old_step.destroy
      end
    end

    new_steps.select { |step| !step.nil? }.each do |step_params|
      # if it has a hashid, we're trying to restore a deleted connection
      if step_params[:hashid]
        id = ScenarioStep.hashids.decode(step_params[:hashid])[0]
        old_steps.create(step_params.permit(:description, :url, :step_order).merge(id: id))
      else
        old_steps.create(step_params.permit(:description, :url, :step_order))
      end
    end
  end

  def track_study_created(researcher, scenario)
    Analytics.instance.study_created(researcher, scenario)
  end

  def track_draft_published(researcher, scenario)
    Analytics.instance.draft_published(researcher, scenario)
  end
end
