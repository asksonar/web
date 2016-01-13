class StudiesController < ApplicationController
  protect_from_forgery with: :null_session

  def show
    @scenario = Scenario.find_by_hashid!(params[:id]).prezi
    track_respondent_landed
  end

  def create
    if params.try(:[], :study).try(:[], :scenario_hashid)
      @scenario = Scenario.find_by_hashid(params[:study][:scenario_hashid])
      if !@scenario.live?
        render status: 500, plain: 'Sorry, this study is no longer active.'
        return
      end

      @scenario_result = service.create_result_and_panelist(@scenario, params[:study][:email])
    else
      @scenario_result = service.create_result(current_user)
    end
    track_launched(@scenario_result.scenario)
    render json: { hashid: @scenario_result.hashid }
  end

  def update
    @scenario_result = ScenarioResult.find_by_hashid!(params[:id])
    service.update(@scenario_result, update_params)
    if params[:status]
      track_action(@scenario_result.scenario)
    end
    render plain: 'OK'
  end

  private

  def update_params
    params.permit(:status, :title)
  end

  def service
    @service ||= ScenarioResultsService.instance
  end

  def analytics
    @analytics ||= Analytics.instance
  end

  def track_respondent_landed
    return if !current_user.nil?
    analytics.respondent_landed(request.remote_ip, @scenario.created_by, @scenario)
  end

  def track_launched(scenario)
    if scenario
      track_respondent_launched(scenario)
    else
      track_my_feedback_launched
    end
  end

  def track_respondent_launched(scenario)
    analytics.respondent_launched(request.remote_ip, scenario.created_by, scenario, @scenario_result)
  end

  def track_my_feedback_launched
    analytics.my_feedback_launched(request.remote_ip, current_user, @scenario_result)
  end

  def track_action(scenario)
    if scenario
      track_respondent_action(scenario)
    else
      track_my_feedback_action
    end
  end

  def track_respondent_action(scenario)
    if @scenario_result.inprogress?
      analytics.respondent_started(request.remote_ip, scenario.created_by, scenario, @scenario_result)
    elsif @scenario_result.completed?
      analytics.respondent_completed(request.remote_ip, scenario.created_by, scenario, @scenario_result)
    elsif @scenario_result.aborted?
      analytics.respondent_aborted(request.remote_ip, scenario.created_by, scenario, @scenario_result)
    end
  end

  def track_my_feedback_action
    if @scenario_result.inprogress?
      analytics.my_feedback_started(request.remote_ip, @scenario_result.created_by, @scenario_result)
    elsif @scenario_result.completed?
      analytics.my_feedback_completed(request.remote_ip, @scenario_result.created_by, @scenario_result)
    elsif @scenario_result.aborted?
      analytics.my_feedback_aborted(request.remote_ip, @scenario_result.created_by, @scenario_result)
    end
  end
end
