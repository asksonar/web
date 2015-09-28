class HighlightsController < ApplicationController
  attr_writer :service
  attr_writer :query

  def service
    @service ||= HighlightsService.instance
  end

  def query
    @query ||= HighlightsQuery.instance
  end

  def new
    @result_step = ResultStep.find_by_hashid(params[:video])
  end

  def create
    @highlight = service.create(highlight_params)
    redirect_to highlight_path(@highlight)
  end

  def edit
    @highlight = query.find_by_hashid(params[:id])
  end

  def update
    @highlight = query.find_by_hashid(params[:id])
    service.update(highlight_params)
    redirect_to highlight_path(@highlight)
  end

  def show
    @highlight = query.find_by_hashid(params[:id])
  end

  def destroy
    @highlight = query.find_by_hashid(params[:id])
    service.destroy(@highlight)
  end

  private

  def highlight_params
    # try(:keys), as opposed to just .keys, lets us compensate for a completely missing hash
    # arrays/objects need to come last, after named keys
    params.require(:highlight).permit(
      :title, :video_time_start, :video_time_end,
      note: params[:highlight][:note].try(:keys), feeling: params[:highlight][:feeling].try(:keys)
    )
  end
end
