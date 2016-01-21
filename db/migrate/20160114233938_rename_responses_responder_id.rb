class RenameResponsesResponderId < ActiveRecord::Migration
  def change
    rename_column :responses, :responder_id, :customer_id
  end
end
