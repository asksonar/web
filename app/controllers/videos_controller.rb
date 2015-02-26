class VideosController < ApplicationController
  def show
    @video = ScenarioStepVideo.find(params[:id])
  end
end
