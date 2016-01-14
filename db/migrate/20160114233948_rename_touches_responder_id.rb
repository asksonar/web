class RenameTouchesResponderId < ActiveRecord::Migration
  def change
    rename_column :touches, :responder_id, :customer_id
  end
end
