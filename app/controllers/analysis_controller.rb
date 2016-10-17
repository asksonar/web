class AnalysisController < ApplicationController
  before_action :authenticate_user!

  def index
    @prezi = prezi
  end

  private

  def prezi
    AnalysisPresenter.new(current_user.company)
  end
end
