class ChangeTableTouchesChangeColumnDateYyyymmdd < ActiveRecord::Migration
  def change
    remove_column :touches, :date_yyyymmdd
    add_column :touches, :date_yyyymmdd, :integer
  end
end
