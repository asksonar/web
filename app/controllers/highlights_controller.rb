class HighlightsController < ApplicationController
  def new
    @scenario_result = ScenarioResult.find_by_hashid(params[:video])
    authorize @scenario_result, :new_highlight?
  end

  def create
    scenario_result = ScenarioResult.find_by_hashid(params[:scenario_highlight][:scenario_result_hashid])
    authorize scenario_result, :create_highlight?
    scenario = scenario_result.scenario
    @scenario_highlight = service.create(highlight_params, scenario, scenario_result)
    redirect_to highlight_path(@scenario_highlight)
  end

  def edit
    @scenario_highlight = ScenarioHighlight.find_by_hashid!(params[:id])
    authorize @scenario_highlight
    @scenario_result = @scenario_highlight.scenario_result
  end

  def update
    @scenario_highlight = ScenarioHighlight.find_by_hashid!(params[:id])
    authorize @scenario_highlight
    service.update(@scenario_highlight, highlight_params)
    redirect_to highlight_path(@scenario_highlight)
  end

  def show
    @scenario_highlight = ScenarioHighlight.find_by_hashid!(params[:id])
    @scenario_result = @scenario_highlight.scenario_result.prezi
    @scenario = @scenario_result.scenario
  end

  def destroy
    @scenario_highlight = ScenarioHighlight.find_by_hashid!(params[:id])
    authorize @scenario_highlight
    service.destroy(@scenario_highlight)
  end

  private

  def service
    @service ||= HighlightsService.instance
  end

  def highlight_params
    # try(:keys), as opposed to just .keys, lets us compensate for a completely missing hash
    # arrays/objects need to come last, after named keys
    params.require(:scenario_highlight).permit(
      :title, :start_seconds, :end_seconds,
      step: params[:scenario_highlight][:step].try(:keys),
      note: params[:scenario_highlight][:note].try(:keys),
      transcript: params[:scenario_highlight][:transcript].try(:keys)
    )
  end
end
