class ChangeTableScenarioStepFeelingsContextTranscription < ActiveRecord::Migration
  def change
    add_column :scenario_step_feelings, :context_transcription, :text
  end
end
