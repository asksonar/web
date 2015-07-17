class RenameTableResultFeelingsToStepFeelings < ActiveRecord::Migration
  def change
    rename_table :result_feelings, :step_feelings
  end
end
