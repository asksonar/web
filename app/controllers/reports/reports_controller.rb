module Reports
  class ReportsController < ApplicationController
    before_action :authenticate_user!

    def index
      @prezi = prezi(query_params)
    end

    private

    def prezi(query_params)
      ReportsPresenter.new(query_params)
    end

    def query_params
      params.permit(:aircraft_type)
    end
  end
end
