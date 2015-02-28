class ChangeTableScenarioStepVideosAddUserId < ActiveRecord::Migration
  def change
    add_column :scenario_step_videos, :user_id, :integer
  end
end
