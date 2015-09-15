class TemplatePresenter < SimpleDelegator
  def public_json
    {
      value: value,
      title: scenario_title,
      description: scenario_description,
      steps: template_steps_array
    }
  end

  def template_steps_array
    template_steps.map do |step|
      {
        description: (step.step_description || '').strip,
        url: (step.step_url || '').strip
      }
    end
  end
end
