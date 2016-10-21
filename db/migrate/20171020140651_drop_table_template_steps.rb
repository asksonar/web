class DropTableTemplateSteps < ActiveRecord::Migration
  def change
    drop_table :template_steps
  end
end
