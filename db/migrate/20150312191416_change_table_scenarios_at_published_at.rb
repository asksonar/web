class ChangeTableScenariosAtPublishedAt < ActiveRecord::Migration
  def change
    add_column :scenarios, :published_at, :datetime
  end
end
