class UsersController < ApplicationController
  before_action :authenticate_researcher!

  def index
    @prezi = prezi
  end

  def prezi
    UsersPresenter.new(company_id: current_researcher.company_id, page: params[:page])
  end
end
