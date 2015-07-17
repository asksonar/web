class ChangeTableResultVideosAddUuidOffsetLength < ActiveRecord::Migration
  def change
    add_column :result_videos, :uuid, :string
    add_column :result_videos, :offset_seconds, :float
    add_column :result_videos, :length_seconds, :float
  end
end
