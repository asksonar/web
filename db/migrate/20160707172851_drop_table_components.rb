class DropTableComponents < ActiveRecord::Migration
  def change
    drop_table :components
  end
end
