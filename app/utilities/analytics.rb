class Analytics
  include Singleton

  def initialize
    @consumer = Mixpanel::Consumer.new
    @tracker = Mixpanel::Tracker.new(Rails.configuration.properties['mixpanel_token']) do |type, message|
      #Resque.enqueue(ProcessMixpanelWorker, type, message)
      @consumer.send!(type, message)
    end
  end

  def researcher_created(researcher)
    @tracker.track(researcher.id, 'Researcher created')
    @tracker.people.set(researcher.id, {
      '$name' => researcher.full_name,
      'Company id' => researcher.company.id,
      'Company hashid' => researcher.company.hashid,
      'Researcher id' => researcher.id,
      'Researcher hashid' => researcher.hashid,
      '$email' => researcher.email,
      '$created' => researcher.created_at
    });
    # map javascript page views (which use hashid) to the researcher id
    @tracker.alias(researcher.hashid, researcher.id)
  end

  def study_created(researcher, scenario)
    @tracker.track(researcher.id, 'Study created', {
      'status' => scenario.status,
      'scenario hashid' => scenario.hashid
    })
    @tracker.people.set(researcher.id, {
      'Last study created' => Time.new
    })
    @tracker.people.plus_one(researcher.id, 'Total study created')
  end

  def draft_published(researcher, scenario)
    @tracker.track(researcher.id, 'Draft published', {
      'scenario hashid' => scenario.hashid
    })
    @tracker.people.set(researcher.id, {
      'Last draft published' => Time.new
    })
    @tracker.people.plus_one(researcher.id, 'Total draft published')
  end

  def result_video_viewed(researcher, scenario, result_step)
    @tracker.track(researcher.id, 'Result video viewed', {
      'scenario hashid' => scenario.hashid,
      'video hashid' => result_step.hashid
    })
    @tracker.people.set(researcher.id, {
      'Last result video viewed' => Time.new
    })
    @tracker.people.plus_one(researcher.id, 'Total result video viewed')
  end

  def share_video_viewed(researcher, ip_address, scenario, result_step)
    @tracker.track(researcher.id, 'Share video viewed', {
      'ip_address' => ip_address,
      'scenario hashid' => scenario.hashid,
      'video hashid' => result_step.hashid
    })
    @tracker.people.set(researcher.id, {
      'Last share video viewed' => Time.new
    })
    @tracker.people.plus_one(researcher.id, 'Total share video viewed')
  end

  def respondent_landed(researcher, ip_address, scenario)
    @tracker.track(researcher.id, 'Respondent landed', {
      'ip_address' => ip_address,
      'scenario hashid' => scenario.hashid
    })
    @tracker.people.set(researcher.id, {
      'Last respondent landed' => Time.new
    })
    @tracker.people.plus_one(researcher.id, 'Total respondent landed')
  end

  def respondent_launched(researcher, ip_address, scenario, scenario_result)
    @tracker.track(researcher.id, 'Respondent launched', {
      'ip_address' => ip_address,
      'scenario hashid' => scenario.hashid,
      'result hashid' => scenario_result.hashid
    })
    @tracker.people.set(researcher.id, {
      'Last respondent launched' => Time.new
    })
    @tracker.people.plus_one(researcher.id, 'Total respondent launched')
  end

  def respondent_started(researcher, ip_address, scenario, scenario_result)
    @tracker.track(researcher.id, 'Respondent started', {
      'ip_address' => ip_address,
      'scenario hashid' => scenario.hashid,
      'result hashid' => scenario_result.hashid
    })
    @tracker.people.set(researcher.id, {
      'Last respondent started' => Time.new
    })
    @tracker.people.plus_one(researcher.id, 'Total respondent started')
  end

  def respondent_completed(researcher, ip_address, scenario, scenario_result)
    @tracker.track(researcher.id, 'Respondent completed', {
      'ip_address' => ip_address,
      'scenario hashid' => scenario.hashid,
      'result hashid' => scenario_result.hashid
    })
    @tracker.people.set(researcher.id, {
      'Last respondent completed' => Time.new
    })
    @tracker.people.plus_one(researcher.id, 'Total respondent completed')
  end

  def respondent_aborted(researcher, ip_address, scenario, scenario_result)
    @tracker.track(researcher.id, 'Respondent aborted', {
      'ip_address' => ip_address,
      'scenario hashid' => scenario.hashid,
      'result hashid' => scenario_result.hashid
    })
    @tracker.people.set(researcher.id, {
      'Last respondent aborted' => Time.new
    })
    @tracker.people.plus_one(researcher.id, 'Total respondent aborted')
  end

  def respondent_uploaded(researcher, ip_address, scenario, scenario_result)
    @tracker.track(researcher.id, 'Respondent uploaded', {
      'ip_address' => ip_address,
      'scenario hashid' => scenario.hashid,
      'result hashid' => scenario_result.hashid
    })
    @tracker.people.set(researcher.id, {
      'Last respondent uploaded' => Time.new
    })
    @tracker.people.plus_one(researcher.id, 'Total respondent uploaded')
  end

end
