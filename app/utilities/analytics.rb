class Analytics
  include Singleton

  def initialize
    @tracker = Mixpanel::Tracker.new(Rails.configuration.properties['mixpanel_token']) do |type, message|
      Resque.enqueue(ProcessMixpanelWorker, type, message)
    end
    @user_agent_parser = UserAgentParser::Parser.new
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

  def modal_video_viewed(researcher, ip_address, scenario_result)
    scenario = scenario_result.scenario
    created_by_id = scenario.created_by.id
    if researcher.nil? || researcher.id != created_by_id
      share_video_viewed(researcher, ip_address, scenario.created_by, scenario, scenario_result, true)
    else
      result_video_viewed(researcher, scenario, scenario_result, true)
    end
  end

  def video_seconds(scenario_result)
    video_seconds = 0

    scenario_result.result_steps.each do |result_step|
      video_seconds += result_step.completed_seconds
    end

    video_seconds
  end

  def result_video_viewed(researcher, scenario, scenario_result, is_modal)
    @tracker.track(researcher.hashid, 'Researcher viewed video', {
      'time' => Time.new,
      'is modal' => is_modal,
      'scenario hashid' => scenario.try(:hashid),
      'video hashid' => scenario_result.hashid,
      'video seconds' => video_seconds(scenario_result)
    })
    @tracker.people.set(researcher.hashid, {
      'Last viewed video' => Time.new
    }, 0)
    @tracker.people.plus_one(researcher.hashid, 'Total viewed video', 0)
  end

  def share_video_viewed(colleague, ip_address, researcher, scenario, scenario_result, is_modal)
    @tracker.track(researcher.hashid, "Researcher's colleague viewed video", {
      'time' => Time.new,
      'is modal' => is_modal,
      'ip_address' => ip_address,
      'scenario hashid' => scenario.try(:hashid),
      'video hashid' => scenario_result.hashid,
      'video seconds' => video_seconds(scenario_result)
    })
    @tracker.track(!colleague.nil? ? colleague.hashid : ip_address, 'Colleague viewed video', {
      'time' => Time.new,
      'is modal' => is_modal,
      'ip_address' => ip_address,
      'scenario hashid' => scenario.try(:hashid),
      'video hashid' => scenario_result.hashid,
      'video seconds' => video_seconds(scenario_result)
    })
    @tracker.people.set(researcher.hashid, {
      'Last colleague viewed video' => Time.new
    }, 0)
    @tracker.people.plus_one(researcher.hashid, 'Total colleague viewed video', 0)
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

  def my_feedback_launched(ip_address, researcher, scenario_result)
    @tracker.track(researcher.hashid, 'My feedback launched', {
      'time' => Time.new,
      'result hashid' => scenario_result.hashid
    })
    @tracker.people.set(researcher.hashid, {
      'Last my feedback launched' => Time.new
    }, 0)
    @tracker.people.plus_one(researcher.hashid, 'Total my feedback launched', 0)
  end

  def my_feedback_started(ip_address, researcher, scenario_result)
    @tracker.track(researcher.hashid, 'My feedback started', {
      'time' => Time.new,
      'result hashid' => scenario_result.hashid
    })
    @tracker.people.set(researcher.hashid, {
      'Last my feedback started' => Time.new
    }, 0)
    @tracker.people.plus_one(researcher.hashid, 'Total my feedback started', 0)
  end

  def my_feedback_completed(ip_address, researcher, scenario_result)
    @tracker.track(researcher.hashid, 'My feedback completed', {
      'time' => Time.new,
      'result hashid' => scenario_result.hashid
    })
    @tracker.people.set(researcher.hashid, {
      'Last my feedback completed' => Time.new
    }, 0)
    @tracker.people.plus_one(researcher.hashid, 'Total my feedback completed', 0)
  end

  def my_feedback_aborted(ip_address, researcher, scenario_result)
    @tracker.track(researcher.hashid, 'My feedback aborted', {
      'time' => Time.new,
      'result hashid' => scenario_result.hashid
    })
    @tracker.people.set(researcher.hashid, {
      'Last my feedback aborted' => Time.new
    }, 0)
    @tracker.people.plus_one(researcher.hashid, 'Total my feedback aborted', 0)
  end

  def my_feedback_uploaded(ip_address, researcher, scenario_result)
    @tracker.track(researcher.hashid, 'My feedback uploaded', {
      'time' => Time.new,
      'result hashid' => scenario_result.hashid
    })
    @tracker.people.set(researcher.hashid, {
      'Last my feedback uploaded' => Time.new
    }, 0)
    @tracker.people.plus_one(researcher.hashid, 'Total my feedback uploaded', 0)
  end
end
