class Analytics
  include Singleton

  def initialize
    @tracker = Mixpanel::Tracker.new(Rails.configuration.properties['mixpanel_token']) do |type, message|
      Resque.enqueue(ProcessMixpanelWorker, type, message)
    end
    @user_agent_parser = UserAgentParser::Parser.new
  end

  def user_created(user)
    @tracker.track(user.hashid, 'User signed up', {
      'time' => Time.new
    })
    @tracker.people.set(user.hashid, {
      '$name' => user.full_name,
      'Company id' => user.company.id,
      'Company hashid' => user.company.hashid,
      'User id' => user.id,
      'User hashid' => user.hashid,
      '$email' => user.email,
      '$created' => user.created_at
    }, 0);
  end
end
