class StudiesVideoController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    scenario_result_hashid = params[:study_id]
    uuid = SecureRandom.uuid

    result_videos_service.create_from_scenario_result_hashid(uuid, scenario_result_hashid)

    render plain: uuid
  end

  def update
    @scenario_result = ScenarioResult.find_by_hashid!(params[:study_id])
    uuid = params[:id]
    Resque.enqueue(ProcessUploadedS3VideoWorker, uuid, params_mute)
    track_uploaded(@scenario_result.scenario)
    render plain: 'OK'
  end

  private

  def result_videos_service
    @result_videos_service ||= ResultVideosService.instance
  end

  def params_step
    JSON.parse(params[:steps_json])
  end

  def params_mute
    return nil if params[:mute].blank?
    JSON.parse(params[:mute]).map do |section|
      {
        start: section['start'] / 1000.0,
        end: section['end'] / 1000.0
      }
    end
  end

  def analytics
    @analytics ||= Analytics.instance
  end

  def track_uploaded(scenario)
    if scenario
      track_respondent_uploaded(scenario)
    else
      track_my_feedback_uploaded
    end
  end

  def track_respondent_uploaded(scenario)
    analytics.respondent_uploaded(request.remote_ip, scenario.created_by, scenario, @scenario_result)
  end

  def track_my_feedback_uploaded
    analytics.my_feedback_uploaded(request.remote_ip, @scenario_result.created_by, @scenario_result)
  end
end
