class DemoController < ApplicationController
  before_action :authenticate_user!

  def index
    @prezi = prezi
  end

  private

  def prezi
    SetupPresenter.new(current_user.company)
  end
end
