class EmbedController < ApplicationController
  before_action :authenticate_researcher!

  def index
    @prezi = prezi
  end

  private

  def prezi
    EmbedPresenter.new(current_researcher.company)
  end
end
