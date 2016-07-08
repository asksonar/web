class ChangeTableDatatableViewsUpdateDatatableFiltersCurrentView < ActiveRecord::Migration
  def change
    execute "
      UPDATE datatable_views
      SET datatable_filters = '{}'
    "
    execute "
      UPDATE datatable_views
      SET current_view = true
    "
  end
end
