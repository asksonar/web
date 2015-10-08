class SubscribeMailingListWorker
  @queue = :mail

  def self.perform(email, list_name)
  end
end
