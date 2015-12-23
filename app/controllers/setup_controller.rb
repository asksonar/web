class EmbedController < ApplicationController
  before_action :authenticate_user!

  def embed
    @prezi = prezi
  end

  private

  def prezi
    EmbedPresenter.new(current_user.company)
  end
end
