class ChangeTableDatatableViewsAddColumnDatatableFilters < ActiveRecord::Migration
  def change
    add_column :datatable_views, :datatable_filters, :text
  end
end
