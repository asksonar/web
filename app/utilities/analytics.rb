class Analytics
  include Singleton

  def initialize
    @consumer = Mixpanel::Consumer.new
    @tracker = Mixpanel::Tracker.new(Rails.configuration.properties['mixpanel_token']) do |type, message|
      #Resque.enqueue(ProcessMixpanelWorker, type, message)
      @consumer.send!(type, message)
    end
    @user_agent_parser = UserAgentParser::Parser.new
  end

  def page_viewed_signed_out(ip_address, request)
    user_agent = @user_agent_parser.parse(request.user_agent)
    @tracker.track(ip_address, 'Page viewed', request.query_parameters.merge({
      'time' => Time.new,
      'action' => request.parameters[:controller] + '#' + request.parameters[:action],
      'is signed in' => false,
      '$browser' =>  user_agent.family,
      '$browser_version' => user_agent.version.nil? ? nil : user_agent.version.major,
      '$os' => user_agent.os.name,
      '$device' => user_agent.device.name,
      '$current_url' => request.url
    }), ip_address)
  end

  def page_viewed_signed_in(researcher, ip_address, request)
    user_agent = @user_agent_parser.parse(request.user_agent)
    @tracker.track(researcher.hashid, 'Page viewed', request.query_parameters.merge({
      'time' => Time.new,
      'action' => request.parameters[:controller] + '#' + request.parameters[:action],
      'is signed in' => true,
      '$browser' =>  user_agent.family,
      '$browser_version' => user_agent.version.nil? ? nil : user_agent.version.major,
      '$os' => user_agent.os.name,
      '$device' => user_agent.device.name,
      '$current_url' => request.url
    }), ip_address)
    @tracker.people.set(researcher.hashid, {
      'Last page viewed' => Time.new,
      '$browser' =>  user_agent.family,
      '$browser_version' => user_agent.version.nil? ? nil : user_agent.version.major,
      '$os' => user_agent.os.name,
      '$device' => user_agent.device.name
    }, ip_address)
    @tracker.people.plus_one(researcher.hashid, 'Total page viewed', 0)
  end

  def researcher_created(researcher)
    @tracker.track(researcher.hashid, 'Researcher signed up', {
      'time' => Time.new
    })
    @tracker.people.set(researcher.hashid, {
      '$name' => researcher.full_name,
      'Company id' => researcher.company.id,
      'Company hashid' => researcher.company.hashid,
      'Researcher id' => researcher.id,
      'Researcher hashid' => researcher.hashid,
      '$email' => researcher.email,
      '$created' => researcher.created_at
    }, 0);
  end

  def study_created(researcher, scenario)
    @tracker.track(researcher.hashid, 'Researcher created study', {
      'time' => Time.new,
      'status' => scenario.status,
      'scenario hashid' => scenario.hashid
    })
    @tracker.people.set(researcher.hashid, {
      'Last created study' => Time.new
    }, 0)
    @tracker.people.plus_one(researcher.hashid, 'Total created study', 0)
  end

  def draft_published(researcher, scenario)
    @tracker.track(researcher.hashid, 'Researcher published draft', {
      'time' => Time.new,
      'scenario hashid' => scenario.hashid
    })
    @tracker.people.set(researcher.hashid, {
      'Last published draft' => Time.new
    }, 0)
    @tracker.people.plus_one(researcher.hashid, 'Total published draft', 0)
  end

  def result_video_viewed(researcher, scenario, result_step, is_modal)
    @tracker.track(researcher.hashid, 'Researcher viewed result video', {
      'time' => Time.new,
      'is modal' => is_modal,
      'scenario hashid' => scenario.hashid,
      'video hashid' => result_step.hashid,
      'video seconds' => result_step.completed_seconds
    })
    @tracker.people.set(researcher.hashid, {
      'Last viewed result video' => Time.new
    }, 0)
    @tracker.people.plus_one(researcher.hashid, 'Total viewed result video', 0)
  end

  def share_video_viewed(colleague, ip_address, researcher, scenario, result_step)
    @tracker.track(researcher.hashid, "Researcher's colleague viewed share video", {
      'time' => Time.new,
      'ip_address' => ip_address,
      'scenario hashid' => scenario.hashid,
      'video hashid' => result_step.hashid,
      'video seconds' => result_step.completed_seconds
    })
    @tracker.track(!colleague.nil? ? colleague.hashid : ip_address, 'Colleague viewed share video', {
      'time' => Time.new,
      'ip_address' => ip_address,
      'scenario hashid' => scenario.hashid,
      'video hashid' => result_step.hashid,
      'video seconds' => result_step.completed_seconds
    })
    @tracker.people.set(researcher.hashid, {
      'Last colleague viewed share video' => Time.new
    }, 0)
    @tracker.people.plus_one(researcher.hashid, 'Total colleague viewed share video', 0)
  end

  def respondent_landed(ip_address, researcher, scenario)
    @tracker.track(ip_address, 'Respondent landed', {
      'time' => Time.new,
      'ip_address' => ip_address,
      'scenario hashid' => scenario.hashid
    })
    @tracker.track(researcher.hashid, "Researcher's respondent landed", {
      'time' => Time.new,
      'ip_address' => ip_address,
      'scenario hashid' => scenario.hashid
    })
    @tracker.people.set(researcher.hashid, {
      'Last respondent landed' => Time.new
    }, 0)
    @tracker.people.plus_one(researcher.hashid, 'Total respondent landed', 0)
  end

  def respondent_launched(ip_address, researcher, scenario, scenario_result)
    @tracker.track(ip_address, 'Respondent launched', {
      'time' => Time.new,
      'ip_address' => ip_address,
      'scenario hashid' => scenario.hashid,
      'result hashid' => scenario_result.hashid
    })
    @tracker.track(researcher.hashid, "Researcher's respondent launched", {
      'time' => Time.new,
      'ip_address' => ip_address,
      'scenario hashid' => scenario.hashid,
      'result hashid' => scenario_result.hashid
    })
    @tracker.people.set(researcher.hashid, {
      'Last respondent launched' => Time.new
    }, 0)
    @tracker.people.plus_one(researcher.hashid, 'Total respondent launched', 0)
  end

  def respondent_started(ip_address, researcher, scenario, scenario_result)
    @tracker.track(ip_address, 'Respondent started', {
      'time' => Time.new,
      'ip_address' => ip_address,
      'scenario hashid' => scenario.hashid,
      'result hashid' => scenario_result.hashid
    })
    @tracker.track(researcher.hashid, "Researcher's respondent started", {
      'time' => Time.new,
      'ip_address' => ip_address,
      'scenario hashid' => scenario.hashid,
      'result hashid' => scenario_result.hashid
    })
    @tracker.people.set(researcher.hashid, {
      'Last respondent started' => Time.new
    }, 0)
    @tracker.people.plus_one(researcher.hashid, 'Total respondent started', 0)
  end

  def respondent_stepped(ip_address, researcher, scenario, scenario_result, scenario_step, result_step)
    @tracker.track(ip_address, 'Respondent stepped', {
      'time' => Time.new,
      'ip_address' => ip_address,
      'scenario hashid' => scenario.hashid,
      'result hashid' => scenario_result.hashid,
      'step order' => scenario_step.step_order,
      'video hashid' => result_step.hashid,
      'video seconds' => result_step.completed_seconds
    })
    @tracker.track(researcher.hashid, "Researcher's respondent stepped", {
      'time' => Time.new,
      'ip_address' => ip_address,
      'scenario hashid' => scenario.hashid,
      'result hashid' => scenario_result.hashid,
      'step order' => scenario_step.step_order,
      'video hashid' => result_step.hashid,
      'video seconds' => result_step.completed_seconds
    })
    @tracker.people.set(researcher.hashid, {
      'Last respondent stepped' => Time.new
    }, 0)
    @tracker.people.plus_one(researcher.hashid, 'Total respondent stepped', 0)
  end

  def respondent_completed(ip_address, researcher, scenario, scenario_result)
    @tracker.track(ip_address, 'Respondent completed', {
      'time' => Time.new,
      'ip_address' => ip_address,
      'scenario hashid' => scenario.hashid,
      'result hashid' => scenario_result.hashid
    })
    @tracker.track(researcher.hashid, "Researcher's respondent completed", {
      'time' => Time.new,
      'ip_address' => ip_address,
      'scenario hashid' => scenario.hashid,
      'result hashid' => scenario_result.hashid
    })
    @tracker.people.set(researcher.hashid, {
      'Last respondent completed' => Time.new
    }, 0)
    @tracker.people.plus_one(researcher.hashid, 'Total respondent completed', 0)
  end

  def respondent_aborted(ip_address, researcher, scenario, scenario_result)
    @tracker.track(ip_address, 'Respondent aborted', {
      'time' => Time.new,
      'ip_address' => ip_address,
      'scenario hashid' => scenario.hashid,
      'result hashid' => scenario_result.hashid
    })
    @tracker.track(researcher.hashid, "Researcher's respondent aborted", {
      'time' => Time.new,
      'ip_address' => ip_address,
      'scenario hashid' => scenario.hashid,
      'result hashid' => scenario_result.hashid
    })
    @tracker.people.set(researcher.hashid, {
      'Last respondent aborted' => Time.new
    }, 0)
    @tracker.people.plus_one(researcher.hashid, 'Total respondent aborted', 0)
  end

  def respondent_uploaded(ip_address, researcher, scenario, scenario_result)
    @tracker.track(ip_address, 'Respondent uploaded', {
      'time' => Time.new,
      'ip_address' => ip_address,
      'scenario hashid' => scenario.hashid,
      'result hashid' => scenario_result.hashid
    })
    @tracker.track(researcher.hashid, "Researcher's respondent uploaded", {
      'time' => Time.new,
      'ip_address' => ip_address,
      'scenario hashid' => scenario.hashid,
      'result hashid' => scenario_result.hashid
    })
    @tracker.people.set(researcher.hashid, {
      'Last respondent uploaded' => Time.new
    }, 0)
    @tracker.people.plus_one(researcher.hashid, 'Total respondent uploaded', 0)
  end

end
