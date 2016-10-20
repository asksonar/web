class DropTableResultNotes < ActiveRecord::Migration
  def change
    drop_table :result_notes
  end
end
