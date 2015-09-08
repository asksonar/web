class VideosJsonController < ApplicationController
  def show
    result_step = ResultStep.find_by_hashid(params[:result_step_hashid])
    if result_step.nil?
      return render status: 500, plain: '<strong>Error Loading Video</strong> - The video could not be found.'
    end

    if result_step.video.nil?
      return render status: 500, plain: '<strong>Error Loading Video</strong> - The video has not yet been uploaded.'
    end

    Analytics.instance.modal_video_viewed(current_researcher, request.remote_ip, result_step)

    result_step_json = ResultStepPresenter.new(result_step).public_json
    scenario_step_json = ScenarioStepPresenter.new(result_step.scenario_step).public_json
    json = result_step_json.merge(scenario_step_json)
    render json: json
  end
end
