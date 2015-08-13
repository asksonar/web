class StudiesController < ApplicationController
  protect_from_forgery with: :null_session

  def show
    @scenario = Scenario.find_by_hashid(params[:id])
    if current_researcher.nil?
      Analytics.instance.respondent_landed(request.remote_ip, @scenario.created_by, @scenario)
    end
  end

  def create
    scenario = Scenario.find_by_hashid(params[:study][:scenario_hashid])

    if !scenario.live?
      render status: 500, plain: 'This study is no longer active.'
      return
    end

    panelist = Panelist.find_by(email: params[:study][:email])
    if panelist.nil?
      panelist = Panelist.create(email: params[:study][:email])
    end

    scenario_result = ScenarioResult.create(scenario: scenario, panelist: panelist)
    render json: {hashid: scenario_result.hashid}

    Analytics.instance.respondent_launched(request.remote_ip, scenario.created_by, scenario, scenario_result)
  end

  def update
    scenario_result = ScenarioResult.find_by_hashid(params[:id])

    status = params[:status]
    scenario_result.status = ScenarioResult.statuses[status]
    scenario_result.save()

    render plain: 'OK'

    scenario = scenario_result.scenario

    if scenario_result.inprogress?
      Analytics.instance.respondent_started(request.remote_ip, scenario.created_by, scenario, scenario_result)
    elsif scenario_result.completed?
      Analytics.instance.respondent_completed(request.remote_ip, scenario.created_by, scenario, scenario_result)
    elsif scenario_result.aborted?
      Analytics.instance.respondent_aborted(request.remote_ip, scenario.created_by, scenario, scenario_result)
    end
  end

end
