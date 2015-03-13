class Template < ActiveRecord::Base
  enum category: [:product, :marketing]
  has_many :template_steps, -> { order step_order: :asc }, inverse_of: :template

  def self.product_templates
    Template.where(category: categories[:product])
  end

  def self.marketing_templates
    Template.where(category: categories[:marketing])
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

end
