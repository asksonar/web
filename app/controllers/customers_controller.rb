class CustomersController < ApplicationController
  before_action :authenticate_user!

  def index
    @prezi = prezi
  end

  def prezi
    CustomersPresenter.new(company_id: current_user.company_id, page: params[:page])
  end
end
