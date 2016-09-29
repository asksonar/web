class ChangeTableAircraftHistoriesChangeColumnTypesV2 < ActiveRecord::Migration
  def change
    remove_column :aircraft_histories, :delivery_date
    add_column :aircraft_histories, :delivery_date, :datetime
  end
end
