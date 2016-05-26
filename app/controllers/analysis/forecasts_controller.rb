module Analysis
  class ForecastsController < ApplicationController
    before_action :authenticate_user!

    def index
      @prezi = ForecastsPresenter.new
    end
  end
end
