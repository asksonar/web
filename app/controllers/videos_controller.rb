class VideosController < ApplicationController
  def show
    @video = ScenarioStepVideo.find_by(video_params)
    render json: @video
  end

  private
    def video_params
      params.permit(:scenario_step_id, :user_id)
    end
end
