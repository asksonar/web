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

  def study_created(user, scenario)
    @tracker.track(user.hashid, 'User created study', {
      'time' => Time.new,
      'status' => scenario.status,
      'scenario hashid' => scenario.hashid
    })
    @tracker.people.set(user.hashid, {
      'Last created study' => Time.new
    }, 0)
    @tracker.people.plus_one(user.hashid, 'Total created study', 0)
  end

  def draft_published(user, scenario)
    @tracker.track(user.hashid, 'User published draft', {
      'time' => Time.new,
      'scenario hashid' => scenario.hashid
    })
    @tracker.people.set(user.hashid, {
      'Last published draft' => Time.new
    }, 0)
    @tracker.people.plus_one(user.hashid, 'Total published draft', 0)
  end

  def video_viewed(user, ip_address, scenario, scenario_result, is_modal)
    scenario = scenario_result.scenario
    created_by = (scenario || scenario_result).created_by
    if user.nil? || user.id != created_by.id
      share_video_viewed(user, ip_address, created_by, scenario, scenario_result, is_modal)
    else
      result_video_viewed(user, scenario, scenario_result, is_modal)
    end
  end

  def result_video_viewed(user, scenario, scenario_result, is_modal)
    @tracker.track(user.hashid, 'User viewed video', {
      'time' => Time.new,
      'is modal' => is_modal,
      'scenario hashid' => scenario.try(:hashid),
      'video hashid' => scenario_result.hashid,
      'video seconds' => scenario_result.prezi.completed_seconds
    })
    @tracker.people.set(user.hashid, {
      'Last viewed video' => Time.new
    }, 0)
    @tracker.people.plus_one(user.hashid, 'Total viewed video', 0)
  end

  def share_video_viewed(colleague, ip_address, user, scenario, scenario_result, is_modal)
    @tracker.track(user.hashid, "User's colleague viewed video", {
      'time' => Time.new,
      'is modal' => is_modal,
      'ip_address' => ip_address,
      'scenario hashid' => scenario.try(:hashid),
      'video hashid' => scenario_result.hashid,
      'video seconds' => scenario_result.prezi.completed_seconds
    })
    @tracker.track(!colleague.nil? ? colleague.hashid : ip_address, 'Colleague viewed video', {
      'time' => Time.new,
      'is modal' => is_modal,
      'ip_address' => ip_address,
      'scenario hashid' => scenario.try(:hashid),
      'video hashid' => scenario_result.hashid,
      'video seconds' => scenario_result.prezi.completed_seconds
    })
    @tracker.people.set(user.hashid, {
      'Last colleague viewed video' => Time.new
    }, 0)
    @tracker.people.plus_one(user.hashid, 'Total colleague viewed video', 0)
  end

  def respondent_landed(ip_address, user, scenario)
    @tracker.track(ip_address, 'Respondent landed', {
      'time' => Time.new,
      'ip_address' => ip_address,
      'scenario hashid' => scenario.hashid
    })
    @tracker.track(user.hashid, "User's respondent landed", {
      'time' => Time.new,
      'ip_address' => ip_address,
      'scenario hashid' => scenario.hashid
    })
    @tracker.people.set(user.hashid, {
      'Last respondent landed' => Time.new
    }, 0)
    @tracker.people.plus_one(user.hashid, 'Total respondent landed', 0)
  end

  def respondent_launched(ip_address, user, scenario, scenario_result)
    @tracker.track(ip_address, 'Respondent launched', {
      'time' => Time.new,
      'ip_address' => ip_address,
      'scenario hashid' => scenario.hashid,
      'result hashid' => scenario_result.hashid
    })
    @tracker.track(user.hashid, "User's respondent launched", {
      'time' => Time.new,
      'ip_address' => ip_address,
      'scenario hashid' => scenario.hashid,
      'result hashid' => scenario_result.hashid
    })
    @tracker.people.set(user.hashid, {
      'Last respondent launched' => Time.new
    }, 0)
    @tracker.people.plus_one(user.hashid, 'Total respondent launched', 0)
  end

  def respondent_started(ip_address, user, scenario, scenario_result)
    @tracker.track(ip_address, 'Respondent started', {
      'time' => Time.new,
      'ip_address' => ip_address,
      'scenario hashid' => scenario.hashid,
      'result hashid' => scenario_result.hashid
    })
    @tracker.track(user.hashid, "User's respondent started", {
      'time' => Time.new,
      'ip_address' => ip_address,
      'scenario hashid' => scenario.hashid,
      'result hashid' => scenario_result.hashid
    })
    @tracker.people.set(user.hashid, {
      'Last respondent started' => Time.new
    }, 0)
    @tracker.people.plus_one(user.hashid, 'Total respondent started', 0)
  end

  def respondent_stepped(ip_address, user, scenario, scenario_result, scenario_step, result_step)
    @tracker.track(ip_address, 'Respondent stepped', {
      'time' => Time.new,
      'ip_address' => ip_address,
      'scenario hashid' => scenario.hashid,
      'result hashid' => scenario_result.hashid,
      'step order' => scenario_step.step_order,
      'video hashid' => result_step.hashid,
      'video seconds' => result_step.completed_seconds
    })
    @tracker.track(user.hashid, "User's respondent stepped", {
      'time' => Time.new,
      'ip_address' => ip_address,
      'scenario hashid' => scenario.hashid,
      'result hashid' => scenario_result.hashid,
      'step order' => scenario_step.step_order,
      'video hashid' => result_step.hashid,
      'video seconds' => result_step.completed_seconds
    })
    @tracker.people.set(user.hashid, {
      'Last respondent stepped' => Time.new
    }, 0)
    @tracker.people.plus_one(user.hashid, 'Total respondent stepped', 0)
  end

  def respondent_completed(ip_address, user, scenario, scenario_result)
    @tracker.track(ip_address, 'Respondent completed', {
      'time' => Time.new,
      'ip_address' => ip_address,
      'scenario hashid' => scenario.hashid,
      'result hashid' => scenario_result.hashid
    })
    @tracker.track(user.hashid, "User's respondent completed", {
      'time' => Time.new,
      'ip_address' => ip_address,
      'scenario hashid' => scenario.hashid,
      'result hashid' => scenario_result.hashid
    })
    @tracker.people.set(user.hashid, {
      'Last respondent completed' => Time.new
    }, 0)
    @tracker.people.plus_one(user.hashid, 'Total respondent completed', 0)
  end

  def respondent_aborted(ip_address, user, scenario, scenario_result)
    @tracker.track(ip_address, 'Respondent aborted', {
      'time' => Time.new,
      'ip_address' => ip_address,
      'scenario hashid' => scenario.hashid,
      'result hashid' => scenario_result.hashid
    })
    @tracker.track(user.hashid, "User's respondent aborted", {
      'time' => Time.new,
      'ip_address' => ip_address,
      'scenario hashid' => scenario.hashid,
      'result hashid' => scenario_result.hashid
    })
    @tracker.people.set(user.hashid, {
      'Last respondent aborted' => Time.new
    }, 0)
    @tracker.people.plus_one(user.hashid, 'Total respondent aborted', 0)
  end

  def respondent_uploaded(ip_address, user, scenario, scenario_result)
    @tracker.track(ip_address, 'Respondent uploaded', {
      'time' => Time.new,
      'ip_address' => ip_address,
      'scenario hashid' => scenario.hashid,
      'result hashid' => scenario_result.hashid
    })
    @tracker.track(user.hashid, "User's respondent uploaded", {
      'time' => Time.new,
      'ip_address' => ip_address,
      'scenario hashid' => scenario.hashid,
      'result hashid' => scenario_result.hashid
    })
    @tracker.people.set(user.hashid, {
      'Last respondent uploaded' => Time.new
    }, 0)
    @tracker.people.plus_one(user.hashid, 'Total respondent uploaded', 0)
  end

  def my_feedback_launched(ip_address, user, scenario_result)
    @tracker.track(user.hashid, 'My feedback launched', {
      'time' => Time.new,
      'result hashid' => scenario_result.hashid
    })
    @tracker.people.set(user.hashid, {
      'Last my feedback launched' => Time.new
    }, 0)
    @tracker.people.plus_one(user.hashid, 'Total my feedback launched', 0)
  end

  def my_feedback_started(ip_address, user, scenario_result)
    @tracker.track(user.hashid, 'My feedback started', {
      'time' => Time.new,
      'result hashid' => scenario_result.hashid
    })
    @tracker.people.set(user.hashid, {
      'Last my feedback started' => Time.new
    }, 0)
    @tracker.people.plus_one(user.hashid, 'Total my feedback started', 0)
  end

  def my_feedback_completed(ip_address, user, scenario_result)
    @tracker.track(user.hashid, 'My feedback completed', {
      'time' => Time.new,
      'result hashid' => scenario_result.hashid
    })
    @tracker.people.set(user.hashid, {
      'Last my feedback completed' => Time.new
    }, 0)
    @tracker.people.plus_one(user.hashid, 'Total my feedback completed', 0)
  end

  def my_feedback_aborted(ip_address, user, scenario_result)
    @tracker.track(user.hashid, 'My feedback aborted', {
      'time' => Time.new,
      'result hashid' => scenario_result.hashid
    })
    @tracker.people.set(user.hashid, {
      'Last my feedback aborted' => Time.new
    }, 0)
    @tracker.people.plus_one(user.hashid, 'Total my feedback aborted', 0)
  end

  def my_feedback_uploaded(ip_address, user, scenario_result)
    @tracker.track(user.hashid, 'My feedback uploaded', {
      'time' => Time.new,
      'result hashid' => scenario_result.hashid
    })
    @tracker.people.set(user.hashid, {
      'Last my feedback uploaded' => Time.new
    }, 0)
    @tracker.people.plus_one(user.hashid, 'Total my feedback uploaded', 0)
  end
end
