class ChangeTableScenarioStepsTemplateStepsAddUrl < ActiveRecord::Migration
  def change
    add_column :scenario_steps, :url, :string
    add_column :template_steps, :step_url, :string
  end
end
