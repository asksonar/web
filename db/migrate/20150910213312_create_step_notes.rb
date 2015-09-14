class CreateStepNotes < ActiveRecord::Migration
  def change
    create_table :step_notes do |t|
      t.integer :result_step_id
      t.float :offset_seconds
      t.text :text

      t.timestamps null: false
    end
  end
end
