class AnalysisController < ApplicationController
  before_action :authenticate_user!

  def wb
    @prezi = AnalysisPresenter.new()
  end

  def pv
    @prezi = AnalysisPresenter.new()
  end
end
