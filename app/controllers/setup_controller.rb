class SetupController < ApplicationController
  before_action :authenticate_user!

  def embed
    @prezi = prezi
  end

  private

  def prezi
    SetupPresenter.new(current_user.company)
  end
end
