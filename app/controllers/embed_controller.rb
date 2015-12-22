class EmbedController < ApplicationController
  before_action :authenticate_user!

  def index
    @prezi = prezi
  end

  private

  def prezi
    EmbedPresenter.new(current_user.company)
  end
end
