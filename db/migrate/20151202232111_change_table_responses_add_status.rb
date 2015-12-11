class ChangeTableResponsesAddStatus < ActiveRecord::Migration
  def change
    add_column :responses, :status, :integer
  end
end
