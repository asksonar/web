class VideosJsonController < ApplicationController
  def show
    @video = ScenarioStepVideo.find_by(video_params)
    json = @video.as_json
    json['user_email'] = @video.user.email
    json['step_description'] = @video.scenario_step.description
    json['step_order'] = @video.scenario_step.step_order
    json['share_link'] = @video.share_link
    render json: json
  end

  private
    def video_params
      params.permit(:scenario_step_id, :user_id)
    end
end