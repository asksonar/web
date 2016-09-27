class ChangeTableAircraftHistoriesChangeColumnTypes < ActiveRecord::Migration
  def change
    change_column :aircraft_histories, "aircraft_id", 'integer USING CAST(aircraft_id AS integer)'
  end
end
