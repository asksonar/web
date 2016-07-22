class ChangeTableFleetsChangeBuildYearAircraftAgeSeatsConfigurationFormat < ActiveRecord::Migration
  def change
    change_column :fleets, :build_year, :text
    change_column :fleets, :aircraft_age, :text
    change_column :fleets, :seats_configuration, :text
  end
end
