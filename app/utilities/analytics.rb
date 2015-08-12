class Analytics
  include Singleton

  def initialize
    @consumer = Mixpanel::Consumer.new
    @tracker = Mixpanel::Tracker.new(Rails.configuration.properties['mixpanel_token']) do |type, message|
      #Resque.enqueue(ProcessMixpanelWorker, type, message)
      @consumer.send!(type, message)
    end
  end

  def page_viewed_signed_out(ip_address, request)
    @tracker.track(ip_address, 'Page viewed', request.query_parameters.merge({
      action: request.parameters[:controller] + '#' + request.parameters[:action],
      signed_in: false
    }))
  end

  def page_viewed_signed_in(researcher, request)
    @tracker.track(researcher.id, 'Page viewed', request.query_parameters.merge({
      action: request.parameters[:controller] + '#' + request.parameters[:action],
      signed_in: false
    }))
    @tracker.people.set(researcher.id, {
      'Last page viewed' => Time.new
    })
    @tracker.people.plus_one(researcher.id, 'Total page viewed')
  end

  def researcher_created(researcher)
    @tracker.track(researcher.id, 'Researcher created')
    @tracker.people.set(researcher.id, {
      '$name' => researcher.full_name,
      'company_id' => researcher.company_id,
      '$email' => researcher.email,
      '$created' => researcher.created_at
    });
  end

  def study_created(researcher, status)
    @tracker.track(researcher.id, 'Study created', {
      status: status
    })
    @tracker.people.set(researcher.id, {
      'Last study created' => Time.new
    })
    @tracker.people.plus_one(researcher.id, 'Total study created')
  end

  def draft_published(researcher)
    @tracker.track(researcher.id, 'Draft published')
    @tracker.people.set(researcher.id, {
      'Last draft published' => Time.new
    })
    @tracker.people.plus_one(researcher.id, 'Total draft published')
  end

  def result_video_viewed(researcher)
    @tracker.track(researcher.id, 'Result video viewed')
    @tracker.people.set(researcher.id, {
      'Last result video viewed' => Time.new
    })
    @tracker.people.plus_one(researcher.id, 'Total result video viewed')
  end

  def share_video_viewed(ip_address, researcher)
    @tracker.track(ip_address, 'Share video viewed', {
      company_id: researcher.company.id,
      researcher_id: researcher.id
    })
    @tracker.people.set(researcher.id, {
      'Last share video viewed' => Time.new
    })
    @tracker.people.plus_one(researcher.id, 'Total share video viewed')
  end

  def respondent_landed(ip_address, researcher)
    @tracker.track(ip_address, 'Respondent landed', {
      company_id: researcher.company.id,
      researcher_id: researcher.id
    })
    @tracker.people.set(researcher.id, {
      'Last respondent landed' => Time.new
    })
    @tracker.people.plus_one(researcher.id, 'Total respondent landed')
  end

  def respondent_launched(ip_address, researcher)
    @tracker.track(ip_address, 'Respondent launched', {
      company_id: researcher.company.id,
      researcher_id: researcher.id
    })
    @tracker.people.set(researcher.id, {
      'Last respondent launched' => Time.new
    })
    @tracker.people.plus_one(researcher.id, 'Total respondent launched')
  end

  def respondent_started(ip_address, researcher)
    @tracker.track(ip_address, 'Respondent started', {
      company_id: researcher.company.id,
      researcher_id: researcher.id
    })
    @tracker.people.set(researcher.id, {
      'Last respondent started' => Time.new
    })
    @tracker.people.plus_one(researcher.id, 'Total respondent started')
  end

  def respondent_completed(ip_address, researcher)
    @tracker.track(ip_address, 'Respondent completed', {
      company_id: researcher.company.id,
      researcher_id: researcher.id
    })
    @tracker.people.set(researcher.id, {
      'Last respondent completed' => Time.new
    })
    @tracker.people.plus_one(researcher.id, 'Total respondent completed')
  end

  def respondent_aborted(ip_address, researcher)
    @tracker.track(ip_address, 'Respondent aborted', {
      company_id: researcher.company.id,
      researcher_id: researcher.id
    })
    @tracker.people.set(researcher.id, {
      'Last respondent aborted' => Time.new
    })
    @tracker.people.plus_one(researcher.id, 'Total respondent aborted')
  end

  def respondent_uploaded(ip_address, researcher)
    @tracker.track(ip_address, 'Respondent uploaded', {
      company_id: researcher.company.id,
      researcher_id: researcher.id
    })
    @tracker.people.set(researcher.id, {
      'Last respondent uploaded' => Time.new
    })
    @tracker.people.plus_one(researcher.id, 'Total respondent uploaded')
  end

end
