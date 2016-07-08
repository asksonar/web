class AnalysisController < ApplicationController
  before_action :authenticate_user!

  def index
    @prezi = AnalysisPresenter.new()
  end
end
