class ExploreController < ApplicationController
  before_action :authenticate_user!

  def index
    @prezi = ExplorePresenter.new()
  end
end
