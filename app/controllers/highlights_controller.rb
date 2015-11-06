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
    @scenario_result = ScenarioResult.find_by_hashid(params[:video])
  end

  def create
    scenario_result = ScenarioResult.find_by_hashid(params[:scenario_highlight][:scenario_result_hashid])
    scenario = scenario_result.scenario
    @scenario_highlight = service.create(highlight_params, scenario, scenario_result)
    redirect_to highlight_path(@scenario_highlight)
  end

  def edit
    @scenario_highlight = query.find_by_hashid(params[:id])
    @scenario_result = @scenario_highlight.scenario_result
  end

  def update
    @scenario_highlight = query.find_by_hashid(params[:id])
    service.update(@scenario_highlight, highlight_params)
    redirect_to highlight_path(@scenario_highlight)
  end

  def show
    @scenario_highlight = query.find_by_hashid(params[:id])
    @scenario_result = @scenario_highlight.scenario_result
    @scenario = @scenario_result.scenario
  end

  def destroy
    @scenario_highlight = query.find_by_hashid(params[:id])
    service.destroy(@scenario_highlight)
  end

  private

  def highlight_params
    # try(:keys), as opposed to just .keys, lets us compensate for a completely missing hash
    # arrays/objects need to come last, after named keys
    params.require(:scenario_highlight).permit(
      :title, :start_seconds, :end_seconds,
      note: params[:scenario_highlight][:note].try(:keys),
      transcript: params[:scenario_highlight][:transcript].try(:keys)
    )
  end
end
