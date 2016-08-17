class AnalysisController < ApplicationController
  before_action :authenticate_user!

  def index
    @prezi = AnalysisPresenter.new(current_user.company)
  end
end
