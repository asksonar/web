class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @prezi = prezi
  end

  private

  def prezi
    DashboardPresenter.new(current_user.company_id)
  end
end
