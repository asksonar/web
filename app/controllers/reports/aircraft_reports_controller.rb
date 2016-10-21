module Reports
  class AircraftReportsController < ApplicationController
    before_action :authenticate_user!

    def index
      @prezi = prezi(query_params)
    end

    private

    def prezi(query_params)
      AircraftReportsPresenter.new(query_params)
    end

    def query_params
      params.permit(:aircraft_model)
    end
  end
end
