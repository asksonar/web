class RenameTableDatatableViewToDatatableViews < ActiveRecord::Migration
  def change
    rename_table :datatable_view, :datatable_views
  end
end
