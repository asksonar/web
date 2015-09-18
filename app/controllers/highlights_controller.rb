class HighlightsController < ApplicationController
  def new
    @result_step = ResultStep.find_by_hashid(params[:video])
  end

  def create
  end

  def edit
  end

  def update
  end

  def show
  end

  def destroy
  end
end
