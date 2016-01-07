class ChangeTableResponsesAddType < ActiveRecord::Migration
  def change
    add_column :responses, :type, :integer

    # set previous responses to type inapp
    execute '
      UPDATE responses
      SET type = 0
    '
  end
end
