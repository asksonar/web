class ChangeTableResponsesAddColumnDateYyyymmdd < ActiveRecord::Migration
  def change
    add_column :responses, :date_yyyymmdd, :integer
  end
end
