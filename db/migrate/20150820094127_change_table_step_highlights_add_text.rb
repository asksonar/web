class ChangeTableStepHighlightsAddText < ActiveRecord::Migration
  def change
    add_column :step_highlights, :text, :text
  end
end
