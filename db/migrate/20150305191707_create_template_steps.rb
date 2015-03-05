class CreateTemplateSteps < ActiveRecord::Migration
  def change
    create_table :template_steps do |t|
      t.integer :template_id
      t.text :step_description
      t.integer :step_order

      t.timestamps null: false
    end
  end
end
