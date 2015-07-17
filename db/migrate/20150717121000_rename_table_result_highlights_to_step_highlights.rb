class RenameTableResultHighlightsToStepHighlights < ActiveRecord::Migration
  def change
    rename_table :result_highlights, :step_highlights
  end
end
