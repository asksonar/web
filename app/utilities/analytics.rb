class Analytics
  include Singleton

  def initialize
    @consumer = Mixpanel::Consumer.new
    @tracker = Mixpanel::Tracker.new(Rails.configuration.properties['mixpanel_token']) do |type, message|
      #Resque.enqueue(ProcessMixpanelWorker, type, message)
      @consumer.send!(type, message)
    end
  end

  def tracker
    @tracker
  end

  def self.tracker
    instance.tracker
  end

end
