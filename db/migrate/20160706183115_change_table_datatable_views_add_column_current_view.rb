class ChangeTableDatatableViewsAddColumnCurrentView < ActiveRecord::Migration
  def change
    add_column :datatable_views, :current_view, :boolean
  end
end
