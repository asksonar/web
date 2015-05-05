class ChangeTableResultStepsRemoveUserId < ActiveRecord::Migration
  def change
    remove_column :result_steps, :user_id
  end
end
