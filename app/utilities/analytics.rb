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
    @tracker.track(researcher.hashid, 'Researcher created')
    @tracker.people.set(researcher.hashid, {
      '$name' => researcher.full_name,
      'Company id' => researcher.company.id,
      'Company hashid' => researcher.company.hashid,
      'Researcher id' => researcher.id,
      'Researcher hashid' => researcher.hashid,
      '$email' => researcher.email,
      '$created' => researcher.created_at
    });
  end

  def study_created(researcher, scenario)
    @tracker.track(researcher.hashid, 'Study created', {
      'status' => scenario.status,
      'scenario hashid' => scenario.hashid
    })
    @tracker.people.set(researcher.hashid, {
      'Last study created' => Time.new
    })
    @tracker.people.plus_one(researcher.hashid, 'Total study created')
  end

  def draft_published(researcher, scenario)
    @tracker.track(researcher.hashid, 'Draft published', {
      'scenario hashid' => scenario.hashid
    })
    @tracker.people.set(researcher.hashid, {
      'Last draft published' => Time.new
    })
    @tracker.people.plus_one(researcher.hashid, 'Total draft published')
  end

  def result_video_viewed(researcher, scenario, result_step)
    @tracker.track(researcher.hashid, 'Result video viewed', {
      'scenario hashid' => scenario.hashid,
      'video hashid' => result_step.hashid,
      'video seconds' => result_step.completed_seconds
    })
    @tracker.people.set(researcher.hashid, {
      'Last result video viewed' => Time.new
    })
    @tracker.people.plus_one(researcher.hashid, 'Total result video viewed')
  end

  def share_video_viewed(researcher, ip_address, scenario, result_step)
    @tracker.track(researcher.hashid, 'Share video viewed', {
      'ip_address' => ip_address,
      'scenario hashid' => scenario.hashid,
      'video hashid' => result_step.hashid,
      'video seconds' => result_step.completed_seconds
    })
    @tracker.people.set(researcher.hashid, {
      'Last share video viewed' => Time.new
    })
    @tracker.people.plus_one(researcher.hashid, 'Total share video viewed')
  end

  def respondent_landed(researcher, ip_address, scenario)
    @tracker.track(researcher.hashid, 'Respondent landed', {
      'ip_address' => ip_address,
      'scenario hashid' => scenario.hashid
    })
    @tracker.people.set(researcher.hashid, {
      'Last respondent landed' => Time.new
    })
    @tracker.people.plus_one(researcher.hashid, 'Total respondent landed')
  end

  def respondent_launched(researcher, ip_address, scenario, scenario_result)
    @tracker.track(researcher.hashid, 'Respondent launched', {
      'ip_address' => ip_address,
      'scenario hashid' => scenario.hashid,
      'result hashid' => scenario_result.hashid
    })
    @tracker.people.set(researcher.hashid, {
      'Last respondent launched' => Time.new
    })
    @tracker.people.plus_one(researcher.hashid, 'Total respondent launched')
  end

  def respondent_started(researcher, ip_address, scenario, scenario_result)
    @tracker.track(researcher.hashid, 'Respondent started', {
      'ip_address' => ip_address,
      'scenario hashid' => scenario.hashid,
      'result hashid' => scenario_result.hashid
    })
    @tracker.people.set(researcher.hashid, {
      'Last respondent started' => Time.new
    })
    @tracker.people.plus_one(researcher.hashid, 'Total respondent started')
  end

  def respondent_stepped(researcher, ip_address, scenario, scenario_result, scenario_step, result_step)
    @tracker.track(researcher.hashid, 'Respondent stepped', {
      'ip_address' => ip_address,
      'scenario hashid' => scenario.hashid,
      'result hashid' => scenario_result.hashid,
      'step order' => scenario_step.step_order,
      'video hashid' => result_step.hashid,
      'video seconds' => result_step.completed_seconds
    })
    @tracker.people.set(researcher.hashid, {
      'Last respondent stepped' => Time.new
    })
    @tracker.people.plus_one(researcher.hashid, 'Total respondent stepped')
  end

  def respondent_completed(researcher, ip_address, scenario, scenario_result)
    @tracker.track(researcher.hashid, 'Respondent completed', {
      'ip_address' => ip_address,
      'scenario hashid' => scenario.hashid,
      'result hashid' => scenario_result.hashid
    })
    @tracker.people.set(researcher.hashid, {
      'Last respondent completed' => Time.new
    })
    @tracker.people.plus_one(researcher.hashid, 'Total respondent completed')
  end

  def respondent_aborted(researcher, ip_address, scenario, scenario_result)
    @tracker.track(researcher.hashid, 'Respondent aborted', {
      'ip_address' => ip_address,
      'scenario hashid' => scenario.hashid,
      'result hashid' => scenario_result.hashid
    })
    @tracker.people.set(researcher.hashid, {
      'Last respondent aborted' => Time.new
    })
    @tracker.people.plus_one(researcher.hashid, 'Total respondent aborted')
  end

  def respondent_uploaded(researcher, ip_address, scenario, scenario_result)
    @tracker.track(researcher.hashid, 'Respondent uploaded', {
      'ip_address' => ip_address,
      'scenario hashid' => scenario.hashid,
      'result hashid' => scenario_result.hashid
    })
    @tracker.people.set(researcher.hashid, {
      'Last respondent uploaded' => Time.new
    })
    @tracker.people.plus_one(researcher.hashid, 'Total respondent uploaded')
  end

end
