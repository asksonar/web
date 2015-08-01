class Template < ActiveRecord::Base
  enum category: [:product, :marketing]
  has_many :template_steps, -> { order step_order: :asc }, inverse_of: :template

  HASHIDS_SALT = '52X^wGkdt6*T'

  def self.product_templates
    Template.product
  end

  def self.marketing_templates
    Template.marketing
  end

  def template_steps_json
    {
      steps: template_steps.map { |step|
        {
          description: (step.step_description || '').strip,
          url: (step.step_url || '').strip
        }
      }
    }.to_json
  end

  def to_scenario(scenario)
    scenario.dup
    scenario.title = scenario_title
    scenario.description = scenario_description
    scenario.scenario_steps = template_steps.map { |step|
      ScenarioStep.new({
        description: (step.step_description || '').strip,
        url: (step.step_url || '').strip
      })
    }
    scenario
  end

end
