class DashboardController < ApplicationController
  before_action :authenticate_researcher!

  def index
    @prezi = prezi
  end

  private

  def prezi
    DashboardPresenter.new(current_researcher.company_id)
  end
end
