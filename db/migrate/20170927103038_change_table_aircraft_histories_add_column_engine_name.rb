class ChangeTableAircraftHistoriesAddColumnEngineName < ActiveRecord::Migration
  def change
    add_column :aircraft_histories, :engine_name, :string
  end
end
