class ChangeTableResultStepAddStatus < ActiveRecord::Migration
  def change
    add_column :result_steps, :status, :integer
    execute '
      UPDATE result_steps
      SET status = 1
    '
  end
end
