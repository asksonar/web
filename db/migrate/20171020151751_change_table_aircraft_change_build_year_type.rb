class ChangeTableAircraftChangeBuildYearType < ActiveRecord::Migration
  def change
    change_column :aircraft, "build_year", 'integer USING CAST(build_year AS integer)'
  end
end
