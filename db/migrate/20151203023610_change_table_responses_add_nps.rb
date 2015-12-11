class ChangeTableResponsesAddNps < ActiveRecord::Migration
  def change
    add_column :responses, :nps, :integer
  end
end
