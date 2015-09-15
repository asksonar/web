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
end
