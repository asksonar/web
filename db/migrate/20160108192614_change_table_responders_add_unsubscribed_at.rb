class ChangeTableRespondersAddUnsubscribedAt < ActiveRecord::Migration
  def change
    add_column :responders, :unsubscribed_at, :datetime
  end
end
