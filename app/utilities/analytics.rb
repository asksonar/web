class Analytics
  include Singleton

  def initialize
    @consumer = Mixpanel::Consumer.new
    @tracker = Mixpanel::Tracker.new(Rails.configuration.properties['mixpanel_token']) do |type, message|
      #Resque.enqueue(ProcessMixpanelWorker, type, message)
      @consumer.send!(type, message)
    end
  end

  def page_viewed_signed_out(ip_address, page_name)
    @tracker.track(ip_address, 'Page Viewed', {
      page_name: page_name,
      signed_in: false
    })
  end

  def page_viewed_signed_in(signed_in, researcher, page_name)
    @tracker.track(researcher.id, 'Page Viewed', {
      page_name: page_name,
      signed_in: true,
      company_id: researcher.company.id,
      researcher_id: researcher.id,
    })
  end

  def researcher_created(researcher)
    @tracker.track(researcher.id, 'Researcher Created', {
      company_id: researcher.company.id,
      researcher_id: researcher.id
    })
    @tracker.people.set(researcher.id, {
      '$name' => researcher.full_name,
      'company_id' => researcher.company_id,
      '$email' => researcher.email,
      '$created' => researcher.created_at
    });
  end

  def study_created(researcher, status)
    @tracker.track(researcher.id, 'Study Created', {
      status: self.status,
      company_id: researcher.company.id,
      researcher_id: researcher.id
    })
  end

  def draft_published(researcher)
    @tracker.track(researcher.id, 'Draft Published', {
      company_id: researcher.company.id,
      researcher_id: researcher.id
    })
  end

  def result_video_viewed(researcher)
    @tracker.track(researcher.id, 'Result Video Viewed', {
      company_id: researcher.company.id,
      researcher_id: researcher.id
    })
  end

  def share_video_viewed(ip_address, researcher)
    @tracker.track(ip_address, 'Share Video Viewed', {
      company_id: researcher.company.id,
      researcher_id: researcher.id
    })
  end

  def respondent_landed(ip_address, researcher)
    @tracker.track(ip_address, 'Respondent Landed', {
      company_id: researcher.company.id,
      researcher_id: researcher.id
    })
  end

  def respondent_launched(ip_address, researcher)
    @tracker.track(ip_address, 'Respondent Launched', {
      company_id: researcher.company.id,
      researcher_id: researcher.id
    })
  end

  def respondent_started(ip_address, researcher)
    @tracker.track(ip_address, 'Respondent Started', {
      company_id: researcher.company.id,
      researcher_id: researcher.id
    })
  end

  def respondent_completed(ip_address, researcher)
    @tracker.track(ip_address, 'Respondent Completed', {
      company_id: researcher.company.id,
      researcher_id: researcher.id
    })
  end

  def respondent_aborted(ip_address, researcher)
    @tracker.track(ip_address, 'Respondent Aborted', {
      company_id: researcher.company.id,
      researcher_id: researcher.id
    })
  end

  def respondent_uploaded(ip_address, researcher)
    @tracker.track(ip_address, 'Respondent Uploaded', {
      company_id: researcher.company.id,
      researcher_id: researcher.id
    })
  end

end
