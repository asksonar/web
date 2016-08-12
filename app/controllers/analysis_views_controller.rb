class AnalysisViewsController < ApplicationController
  before_action :authenticate_user!

  def create
    @prezi = prezi(pivot_params: pivot_params)
    analysis_view = @prezi.create_analysis_view(params[:name])

    render json: {
      name: analysis_view.name,
      hashid: analysis_view.hashid
    }
  end

  def show
    @prezi = prezi()
    @prezi.update_current_view(params[:id])
    redirect_to analysis_index_path
  end

  def destroy
    @prezi = prezi()
    @prezi.delete_analysis_view(params[:id])

    flash[:info] = '<strong>Your view has been deleted.</strong>'
    render json: { redirect_url: analysis_index_path }
  end

  private

  def prezi(pivot_params: {})
    AnalysisViewsPresenter.new(current_user.company, pivot_params)
  end

  def pivot_params
    params.fetch(:pivot_params, {}).permit(
      :rowArray => [],
      :colArray => [],
      :filters => [
        "Aircraft Age": [],
        "Aircraft Series": [],
        "Aircraft Type": [],
        "Build Year": [],
        "Engine Model": [],
        "Engine Variant": [],
        "Operator": [],
        "Operator Country": [],
        "Operator Region": [],
        "Seats Configuration": [],
        "Aircraft Status": [],
        "Aircraft Manufacturer": [],
        "Aircraft Model": []
      ],
      :renderer => [:name, :type],
      :aggregator => [:name, :params => []]
    )
  end
end
