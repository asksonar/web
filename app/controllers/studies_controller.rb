class StudiesController < ApplicationController
  protect_from_forgery with: :null_session

  after_action :track_respondent_landed, only: :show
  after_action :track_respondent_launched, only: :create
  after_action :track_respondent_action, only: :update

  attr_writer :service

  def service
    @service ||= ScenarioResultsService.instance
  end

  def show
    @scenario = Scenario.find_by_hashid(params[:id])
  end

  def create
    @scenario = Scenario.find_by_hashid(params[:study][:scenario_hashid])

    if !@scenario.live?
      render status: 500, plain: 'This study is no longer active.'
      return
    end

    @scenario_result = service.create_result_and_panelist(@scenario, params[:study][:email])
    render json: { hashid: @scenario_result.hashid }
  end

  def update
    @scenario_result = ScenarioResult.find_by_hashid(params[:id])
    @scenario = @scenario_result.scenario
    service.update_result_status(@scenario_result, params[:status])
    render plain: 'OK'
  end

  def track_respondent_landed
    return if !current_researcher.nil?
    Analytics.instance.respondent_landed(request.remote_ip, @scenario.created_by, @scenario)
  end

  def track_respondent_launched
    Analytics.instance.respondent_launched(request.remote_ip, @scenario.created_by, @scenario, @scenario_result)
  end

  def track_respondent_action
    if @scenario_result.inprogress?
      Analytics.instance.respondent_started(request.remote_ip, @scenario.created_by, @scenario, @scenario_result)
    elsif @scenario_result.completed?
      Analytics.instance.respondent_completed(request.remote_ip, @scenario.created_by, @scenario, @scenario_result)
    elsif @scenario_result.aborted?
      Analytics.instance.respondent_aborted(request.remote_ip, @scenario.created_by, @scenario, @scenario_result)
    end
  end

end
