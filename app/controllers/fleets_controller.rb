class FleetsController < ApplicationController
  before_action :authenticate_user!

  def index
    @prezi = prezi
  end

  def prezi
    FleetsPresenter.new(display_count: params[:display_count] || 25)
  end
end
