class ChangeTableAircraftHistoriesChangeColumnTypesV1 < ActiveRecord::Migration
  def change
    change_column :aircraft_histories, :delivery_date, :string
  end
end
